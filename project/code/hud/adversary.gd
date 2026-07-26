class_name Adversary extends RefCounted

enum { BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, AP = 1, RESOURCE_SHIFT = 1,
	PERIOD = 1, DURATION = 1, YELLOW, BAR_TYPE = 2, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 2, RED,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, BARS = 4, MAX = 10, SEMI = 100, SET = 255 }

const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]
var aura: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]

var max_points: PackedByteArray = [0, 0, 0, 0]
var points: PackedByteArray = [0, 0, 0, 0]
var damage: PackedByteArray = [0, 1, 0]

var _reaction: Array[Tween]
var last_color: Color

func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink

func resource(hero: int) -> int: return points[hero * 2 + 1]

func transport(hero: int) -> void:
	var h: CharacterBody2D = HUD.level.entity[hero]
	h.animation.transport()
	h.process_mode = Node.PROCESS_MODE_DISABLED
	var shift: int = 1 if Bit.of(h.state[TRANSPORT], hero) else -1
	h.state[2] = posmod(h.state[2] + shift, len(HUD.level.spawn))
	h.position = HUD.level.spawn[h.state[2]]

func ko(hero: int) -> void:
	var over: bool = true
	for i in Def.ENEMY:
		over = over and HUD._status != null and Bit.of(HUD.status.state[i], Def.DEAD)
	if over:
		HUD.level.group.spectrum()
	else:
		HUD.level.entity[hero].animation.play_coma()

func transport_entity(hero: int) -> void:
	if HUD.entity[hero].is_in_group("enemy"):
		transport(hero)
	else:
		ko(hero)
	HUD.status.state[hero] = Bit.to0(HUD.status.state[hero], Def.DEAD)

func diffusion() -> void:
	for hero in len(HUD.entity):
		if Bit.of(HUD.status.state[hero], Def.DEAD):
			transport_entity(hero)

func decide(a: int, b: int, segment: float) -> float:
	return 1.0 / (color[a] - color[b]) * (segment - color[b])

func _between(a: int, segment: float, b: int) -> bool:
	return color[a] > segment and segment >= color[b]

func react(hero: int) -> void:
	var segment: float = HUD.points[hero] / HUD.maximum[hero]
	aura[LAST_THICKNESS] = segment * THICKNESS + 3
	set_material(hero, &"shader_parameter/line_color", last_color)
	if segment <= color[RED]:
		last_color = Color.from_rgba8(SET, NO, NO, SEMI)
	elif segment >= color[BLUE]:
		last_color = Color.from_rgba8(NO, SET, SET, SEMI)
	elif _between(BLUE, segment, GREEN):
		last_color = Color.from_rgba8(NO, SET, int(SET * decide(BLUE, GREEN, segment)), SEMI)
	elif _between(GREEN, segment, YELLOW):
		last_color = Color.from_rgba8(int((1.0 - decide(GREEN, YELLOW, segment)) * SET), SET, NO, SEMI)
	else:
		last_color = Color.from_rgba8(SET, int(SET * decide(YELLOW, RED, segment)), NO, SEMI)

func set_material(hero: int, param: StringName, value: Variant) -> void:
	HUD.level.entity[hero].profile.material.set(param, value)

func set_points(hero: int, type: int, amount: int) -> void:
	var pts: int = clampi(HUD.points[hero][type] + amount, NO, HUD.maximum[hero][type])
	var no: int = hero * BARS + type * BAR_TYPE
	for i in range(no, no + BAR_TYPE):
		HUD.game.points[i].value = pts

func transfusion(hero: int) -> void:
	var no: int = hero * BAR_TYPE
	_reaction[no] = HUD.aura_time.create_tween()
	_reaction[no].tween_method(func():
		set_material(hero, &"shader_parameter/line_color", last_color)
		set_material(hero, &"shader_parameter/line_thickness", aura[LAST_THICKNESS]),
	0.0, 1.0, 1)

func affect_aura(hero: int, amount: int = -1) -> void:
	set_points(hero, Vector2.Axis.AXIS_X, amount)
	HUD.status.state[hero] = Bit.to(HUD.status.state[hero], Def.DEAD, HUD.points[hero] == NO)
	HUD.game.set_hp(hero, HUD.points)
	if Bit.of(HUD.status.state[hero], Def.DEAD) and HUD.entity[hero].is_in_group(&"enemy"):
		HUD.aura_time.start()
	else:
		transfusion(hero)

func costly(hero: int, cost: int) -> bool: return HUD.points[hero] - cost < NO
# TODO FIXME difficulty infinite usage
# func infinite() -> bool: return Bit.of_field(HUD.settings_state, Def.DIFFICULTY) == Def.CASUAL

func _react_resource(hero: int) -> Callable:
	return func(value: float):
		set_material(hero, &"shader_parameter/ap", HUD.points[hero].y)
		if value == 1.0:
			HUD.level.entity[hero].state[RESOURCE] = Bit.to0(HUD.level.entity[hero].state[RESOURCE], hero)
			set_material(hero, &"shader_parameter/action", false)

func affect_resource(hero: int, amount: int = 1) -> void:
	set_points(hero, Vector2.Axis.AXIS_Y, amount)
	set_material(hero, &"shader_parameter/action", true)
	if not Bit.of(HUD.level.entity[hero].state[RESOURCE], hero):
		var no: int = hero * BAR_TYPE + RESOURCE_SHIFT
		HUD.level.entity[hero].state[RESOURCE] = Bit.to1(HUD.level.entity[hero].state[RESOURCE], hero)
		_reaction[no] = HUD.aura_time.create_tween()
		_reaction[no].tween_method(_react_resource(hero), 0.0, 1.0, 1.0)

func thrown(box: CharacterBody2D) -> void:
	if box.velocity != Vector2.ZERO: affect_aura(10)



enum { BURN }

var timing: PackedByteArray = [0, 1, 0]

func set_status(hero: int, type: int) -> void:
	var tween: Tween = HUD.aura_time.create_tween()
	match type:
		BURN: tween.tween_method(func(): burns(hero), timing[hero], 0, 1)

func burns(hero: int) -> void:
	pass
	"""
	if points.alive: _apply_damage(amount)
	HUD.level.aura.affect_aura(hero, -1)
	damage[SUMMARY] = max(damage[SUMMARY] - period, 0)
	if damage[SUMMARY] == 0:
		HUD.aura_time.stop()
	"""




const foe: Array[PackedScene] = [
	preload("res://pre/adversary/foe/eye_seeker.tscn"),
	preload("res://pre/adversary/foe/eye_seeker.tscn")
]


extends Node

const SOURCE = 4

var places: Array[Vector2i]
var lay: Node

func set_spawn(_lay: Node) -> void:
	lay = _lay
	places = lay.tags.layer.get_used_cells_by_id(SOURCE)

func from_pool(no: Dictionary, pool: Node, type: String) -> CharacterBody2D:
	return pool.get(type)[randi_range(0, no[type].size() - 1)].instantiate()

func decide(map: int, type: Array[PackedScene]) -> Array[int]:
	var monsters: Array[int] = []
	for i in range(0, type.size()):
		if Works.is_bit(map, i): monsters.append(i)
	return monsters

func select(pool: Node) -> Dictionary:
	return {
		"foe": decide(lay.tags.layer.monsters, pool.foe),
		"boss": decide(lay.tags.layer.bosses, pool.boss)
	}

func initiate(enemy: CharacterBody2D, i: int, tag: Vector2i) -> void:
	lay.execute.layer.add_child(enemy)
	teleport(enemy, i, lay.execute.get_pos(tag))

func teleport(enemy: CharacterBody2D, spawn: int, tag: Vector2) -> void:
	enemy.spawn_pos = spawn
	enemy.teleport(tag)

func dead(enemy: CharacterBody2D) -> void:
	var i: int = (enemy.spawn_pos + 1) % places.size()
	teleport(enemy, i, lay.execute.get_pos(places[i]))



extends RefCounted

class_name EnemyHUD

var boss_fight: bool = false

var foe: Node # var cards: Array
var card: Array
var hits: int = 0
var xp: Node

const CONTEST_TIME: float = 1.5
const DELAY: float = 0.2
const EXP: int = 1

var tween: Dictionary = {}

func set_timer(enemy: Node) -> void:
	foe = enemy
	foe.hud_reseter.timeout.connect(reset_stats)

func set_achievement() -> void: if hits >= 999: pass # set after 999 hits in a row

func setup(enemy: CharacterBody2D) -> void:
	var health: Node = enemy.logic.processor.health
	var hp: Node = health.points
	hp.update_bar.connect(func(_v): set_cards(in_game[enemy.caption], hp))
	health.interrogation.connect(func(): set_cards(in_game[enemy.caption], hp))

func _set_contested_health(id: int, health: ProgressBar, hp: Node) -> void:
	if tween.has(id): tween[id].kill()
	tween[id] = foe.create_tween()
	if hp.points == 0:
		health.value = hp.maximum
	else:
		health.value = hp.contested
	tween[id].tween_property(health, "value", hp.points, CONTEST_TIME).set_delay(DELAY)

func set_health(c: PanelContainer, hp: Node) -> void:
	for bar in [c.health, c.contested]:
		bar.max_value = hp.maximum
	c.health.value = hp.points
	_set_contested_health(c.get_instance_id(), c.contested, hp)

func set_damage(c: PanelContainer, hp: Node) -> void:
	var interrogation: bool = hp.contested == 0
	c.caption.interrogating = hp.points <= 0
	c.set_hp(hp)
	c.caption.show_start()
	# c.interrogate.visible = interrogation
	c.damage.visible = !interrogation

func set_hits(c: PanelContainer) -> void:
	if hits >= 2:
		c.hits.show()
		c.hits.set_count(hits)
		set_achievement()

func set_stats(c: PanelContainer, _enemy: String, hp: Node) -> void:
	# c.caption.text = enemy
	c.appear()
	set_health(c, hp)
	set_damage(c, hp)
	set_hits(c)
	foe.hud_reseter.start()

func set_cards(enemy: String, hp: Node):
	hits += 1
	if hp.points != 0: xp.add_exp(EXP)
	for c in card: 
		set_stats(c, enemy, hp)

func reset_stats() -> void:
	hits = 0 # caption = ""
	for c in card:
		c.damage.hide()
		c.hits.hide_all()
		if not boss_fight and c.modulator.appeared:
			c.disappear()

var in_game: Dictionary = { "eye-seeker": "Гляделкинс" }




class_name PlayerXP extends RefCounted

var multiply: Timer
var summary: Dictionary = MakeStats.summary()
var prev: Dictionary = summary


func _init(timer: Timer) -> void:
	multiply = timer
	remember_progress() # func sync_points(hero: String, kind: String, value: int) -> void: summary.hero[hero].points[kind] = value

func level_up(i: Dictionary) -> void: i.of[i.at] += 1

func get_exp() -> Vector2: return Vector2i(summary.xp, priority.next)

func level_up(hero: String) -> void:
	var i: Dictionary = summary.hero[hero]
	
	priority.level_up(i)
	priority.prevent_new_levels(i)

func level_up_heroes() -> void:
	for hero in summary.hero: level_up(hero)

func circle_level_up(amount: int) -> bool:
	summary.xp += roundi(amount * multiply.last.y) # amount
	if priority.collecting(summary): return false
	
	prev = summary.duplicate(true)
	while summary.xp >= priority.next:
		summary.xp -= priority.next
		level_up_heroes()
		priority.set_next_level_xp()
	
	return true

func remember_progress() -> void:
	priority.set_xp()
	var maxed: int = 0
	for i in range(0, priority.MAX):
		maxed += priority.remember(summary.hero.ray.of[i])
	priority.priorities_end(maxed)




const BASE: Dictionary = { "ray": [1, 2, 0, 2, 100, 20], "rock": [2, 1, 1, 1, 100, 20] } # ray, p: 5, 5  rock, p: 7, 3

func make_priorities(priorities: Array, stats: Array) -> void:
	for i in range(0, len(priorities)):
		MakeStats.stats(stats, Vector2i(i, priorities[i]))

func calculate(heroes: Dictionary) -> Dictionary:
	var stats: Dictionary = {}
	for hero in BASE:
		stats[hero] = BASE[hero].duplicate()
		make_priorities(heroes[hero].of, stats[hero])
	return stats



signal update_exp(value: Vector2i, base: int)
signal update_priorities(level: Node, stats: Dictionary)

enum STAT { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3, HP = 4, AP = 5, MAX = 6 }
enum PRIORITIES { PURSUIT = 0, SELF_CONTROL = 1, TENACITY = 2 }

const PRIORITY: Array[Array] = [[3, 2, 1, 1], [1, 3, 1, 2], [1, 1, 3, 2]]
const BASE: Dictionary = { "ray": [1, 2, 0, 2, 100, 20], "rock": [2, 1, 1, 1, 100, 20] } # ray, p: 5, 5  rock, p: 7, 3

var level: LevelUpXP

func _init(multiply: Timer) -> void: level = LevelUpXP.new(multiply)

func make_priorities(priorities: Array, values: Array) -> void:
	for i in range(0, len(priorities)): stats(values, Vector2i(i, priorities[i]))

func calculate(heroes: Dictionary) -> Dictionary:
	var values: Dictionary = {}
	for hero in BASE:
		values[hero] = BASE[hero].duplicate()
		make_priorities(heroes[hero].of, values[hero])
	return values

func current_stats() -> Dictionary: return calculate(level.summary.hero)

func sync() -> void: sync_stats() ; experience()
func experience() -> void: update_exp.emit(level.get_exp(), level.priority.base_xp)
func sync_stats() -> void: # var prior: Dictionary = { "summary": level.summary, "prev": level.prev }
	update_priorities.emit(level, { "stats": current_stats(), "prev": calculate(level.prev.hero) })

func add_exp(amount: int) -> void: # print("XP: ", amount, " x %.f" % multiply.last.y, " = ", roundi(amount * multiply.last.y))
	if level.circle_level_up(amount): sync_stats()
	experience()

static func _points(stat: Array, add: Array, pts: Array) -> void:
	stat[pts[0]] += add[pts[1]] * 2 + add[pts[2]]

static func stats(stat: Array, priority: Vector2i) -> void:
	var add: Array = PRIORITY[priority.x]
	for i in range(STAT.POWER, STAT.HP):
		stat[i] += add[i] * priority.y
	for i in [[STAT.HP, STAT.VITALITY, STAT.POWER],
		[STAT.AP, STAT.REACTION, STAT.INFLUENCE]]:
		_points(stat, add, i)

static func delta(current: Array, previous: Array) -> Array:
	var deltas: Array = []
	for stat in range(STAT.POWER, STAT.MAX):
		deltas.append(current[stat] - previous[stat])
	return deltas

static func hexagon() -> Array[int]:
	return [STAT.VITALITY, STAT.REACTION, STAT.AP, STAT.INFLUENCE, STAT.POWER, STAT.HP]

static func summary() -> Dictionary:
	return {
		"xp": 0, "hero": {
			"ray": { "at": 0, "of": [0, 0, 0], "stat": { "h": 9, "a": 11, "buff": [] }, },
			"rock": { "at": 0, "of": [0, 0, 0], "stat": { "h": 11, "a": 9, "buff": [] } },
		}
	}



signal update_meter(time: float, maximum: float)
signal update_x(multiplier: float)
signal finish()

const MAX: int = 1.0 # Progress to 2-3 with hero sum of reaction later
const BASE: int = 1.0

@onready var delay: Timer = $delay

var drop: Dictionary = Skills.drop
var multiplier: Dictionary = Skills.multiplier
var last: Vector2 = Vector2.ONE
var duration: float = MAX

func _ready() -> void:
	timeout.connect(meter_feedback)
	delay.timeout.connect(_start_timer)

func stop_meter() -> void:
	stop()
	last.y = BASE
	finish.emit()
	duration = MAX

func meter_feedback() -> void:
	duration -= wait_time
	update_combo_meter()
	if duration <= 0:
		stop_meter()

func _update() -> void:
	update_multiplier()
	update_combo_meter()

func update_combo_meter() -> void:
	update_meter.emit(duration, MAX)

func update_multiplier() -> void:
	update_x.emit(last.y)

func by_slots(slots: int) -> void:
	if multiplier[slots] > last.y:
		last = Vector2(slots, multiplier[slots])
	_update()
	_start_delay()
	# start()

func _start_timer() -> void:
	start()

func _start_delay() -> void:
	stop()
	delay.start()

func hit() -> void:
	if last.y <= BASE: return
	duration = MAX
	last.y -= drop[int(last.x)]
	if last.y <= BASE:
		stop_meter()
	else:
		update_multiplier()
		_start_delay()




enum { MAX = 3, MAX_LV = 7, BASE_NEXT = 10 }

const MULTIPLIER: float = 1.2

var next: int = 0
var base_xp: int = 0

func maxed_out(of: Array, priority: int) -> bool: return of[priority] >= MAX_LV

func collecting(summary: Dictionary) -> bool: return next == 0 or summary.xp < next

func close_damage(hero: int) -> void:
	for foe in HUD.level.entity[hero].enemy:
		HUD.level.aura.affect_aura(foe, -Def.pow[hero][POWER])

func shift_priority(i: Dictionary) -> int:
	var maxed: int = 0
	while maxed_out(i.of, i.at) and maxed < MAX:
		maxed += 1
		i.at = (i.at + 1) % MAX
	return maxed

func priorities_end(priority: int) -> void: if priority == MAX: next = 0

func prevent_new_levels(i: Dictionary) -> void: priorities_end(shift_priority(i))

func set_xp(base: int = 0, target: int = BASE_NEXT) -> void:
	base_xp = base
	next = target

func set_next_level_xp() -> void: set_xp(base_xp + next, int(next * MULTIPLIER))

func remember(level: int) -> int:
	for j in range(0, level): set_next_level_xp()
	return 1 if level == MAX_LV else 0



@onready var cooldown: Timer = $cooldown
"""
@onready var stats: RecoveryStats = RecoveryStats.new()

func recover(hero: CharacterBody2D, type: String) -> void:
	stats.start_recover(type, hero)
	start()

func stop_recover(hero: CharacterBody2D, type: String) -> void:
	stats.stop_recover(type, hero)
	if stats.no_one(): stop()

func stop_if(act: String, ap_act: String, ap: Callable) -> bool:
	var stopped: bool = not stats.get(act).call()
	if stats.get(ap_act).call("ap"):
		stopped = stopped and not ap.call()
	return stopped

func recover_cooldown() -> void:
	if stop_if("hp_fill", "middle", stats.ap_fill):
		cooldown.stop()

func stop_period() -> void:
	if (stop_if("hp_recover", "enough", stats.ap_recover) or
		stats.no_one()): stop()

func recover_period() -> void:
	stop_period()
	if stats.can_fill(): cooldown.start()
	
"""
