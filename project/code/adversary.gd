class_name Adversary extends RefCounted

enum { BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, AP = 1, RESOURCE_SHIFT = 1,
	PERIOD = 1, DURATION = 1, YELLOW, BAR_TYPE = 2, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 5, RED = 3,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, BARS = 4, MAX = 10, SEMI = 100, SET = 255 }

var aura_stat: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var status_time: PackedByteArray = []
var status_type: PackedByteArray = []
var entities: int = 0
var entity: Array[CharacterBody2D] = [null, null, null, null, null, null, null, null, null, null, null, null, null, null]
var tweens: Array[Tween] = [null, null, null, null, null, null, null, null, null, null, null, null, null, null]
var i_points: PackedByteArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var a_portion: PackedFloat32Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var r_portion: PackedFloat32Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var a_points: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var r_points: PackedByteArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var target_a: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var target_r: PackedByteArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var a_max: PackedByteArray = [0, 0]
var r_max: PackedByteArray = [0, 0]
var h_pow: PackedByteArray = [1, 2]
var h_shl: PackedByteArray = [0, 1]
var h_imp: PackedByteArray = [2, 1]
var h_rct: PackedByteArray = [2, 1]
var last_color: Color

enum { RAY, ROCK, EYE_SEEKER }
enum STAT { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3, HP = 4, AP = 5, MAX = 6 }
enum PRIORITIES { PURSUIT, SELF_CONTROL, TENACITY }
enum { BURN, POISON, COUGH }

const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]
const PRIORITY: PackedByteArray = [3, 2, 1, 1,  1, 3, 1, 2,  1, 1, 3, 2]
const aura: PackedInt32Array = [100, 100,  0] # ray, p: 5, 5  rock, p: 7, 3
const resc: PackedInt32Array = [ 20,  20, 50]
const shell: PackedByteArray = [  0,   1,  5]
const power: PackedByteArray = [  1,   2,  5]
const impac: PackedByteArray = [  2,   1,  5]
const react: PackedByteArray = [  2,   1,  5]
const exper: PackedByteArray = [  0,   0,  1]
const weakn: PackedByteArray = [NORMAL, NORMAL, NORMAL]
const immun: PackedByteArray = [NORMAL, NORMAL, NORMAL]

var in_game: PackedStringArray = ["Гляделкинс"]
var s_power: PackedByteArray = [5, 6]
var status_tick: bool = false

# func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink

func status_feedback(limit: int, enemy: int, time: int, status: int) -> int:
	for j in range(0, limit):
		var t: int = Def.of_x(Def.MASK3, time, j)
		if t != 0:
			match Def.of_x(Def.MASK3, status, j):
				BURN: affect(enemy, -min(1, aura[enemy] >> s_power[BURN]), 0)
				POISON: affect(enemy, -min(1, aura[enemy] >> s_power[POISON]), 0)
			if status_tick:
				t -= 1
				time = Def.to_x(Def.MASK3, time, j, t)
	return time

func status_timeout() -> void:
	var off: bool = true
	status_tick = !status_tick
	for i in range(0, Def.PARTY):
		var time: int = HUD.get_half(HUD.STATUS_TIME, i)
		if time != 0:
			off = false
			HUD.set_half(HUD.STATUS_TIME, status_feedback(4, i, time, HUD.get_half(HUD.STATUS, i)))
	for i in range(0, len(status_time)):
		if status_time[i] != 0: # Def.of_x(Def.MASK4, , )
			off = false
			status_time[i] = status_feedback(2, i + Def.PARTY, status_time[i], status_type[i])
	if off: HUD.aura_timer.stop()

func decide(a: int, b: int, segment: float) -> float:
	return 1.0 / (color[a] - color[b]) * (segment - color[b])

func color_reaction(segment: float) -> Color:
	if segment <= color[RED]: return Color.from_rgba8(SET, NO, NO, SEMI)
	elif segment >= color[BLUE]: return Color.from_rgba8(NO, SET, SET, SEMI)
	elif BLUE > segment and segment >= GREEN: return Color.from_rgba8(NO, SET, int(SET * decide(BLUE, GREEN, segment)), SEMI)
	elif GREEN > segment and segment >= YELLOW: return Color.from_rgba8(int((1.0 - decide(GREEN, YELLOW, segment)) * SET), SET, NO, SEMI)
	return Color.from_rgba8(SET, int(SET * decide(YELLOW, RED, segment)), NO, SEMI)

func _get_ui() -> Array[Control]: return [HUD.game.inventory.points, HUD.game.priorities.points]

func affect(hero: int, a: int, r: int) -> void:
	if !tweens[hero] or !tweens[hero].is_valid():
		tweens[hero] = HUD.create_tween()
		tweens[hero].tween_method(func(value: float):
			var segment: float = a_portion[hero]
			var h: int = hero
			var stat: int
			if hero < Def.PARTY:
				stat = HUD.get_stat(HUD.AURA, hero)
			else:
				h -= Def.PARTY
				stat = a_points[h]
			if target_a[hero] < stat:
				segment = (target_a[hero] + value * (stat - target_a[hero])) * segment
			else:
				segment = (target_a[hero] - value * (target_a[hero] - stat)) * segment
			entity[hero].profile.material.set(&"shader_parameter/line_color", color_reaction(segment))
			entity[hero].profile.material.set(&"shader_parameter/line_thickness", 7 - segment * THICKNESS)

			if hero < Def.PARTY:
				stat = HUD.get_stat(HUD.RESOURCE, hero)
			else:
				stat = r_points[h]
			
			segment = r_portion[hero]
			if target_r[hero] < stat:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			else:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			entity[hero].profile.material.set(&"shader_parameter/ap", segment)

			if hero >= Def.PARTY and i_points[hero] > 0:
				i_points[hero] -= 5
				HUD.game.ability.health.value = i_points[h],
		0, 1.0, 3).tween_callback(func():
			entity[hero].profile.material.set(&"shader_parameter/line_color", Color.TRANSPARENT)
			entity[hero].profile.material.set(&"shader_parameter/action", false)
			if hero < Def.PARTY:
				if HUD.get_stat(HUD.AURA, Def.RAY) == 0 and HUD.get_stat(HUD.AURA, Def.ROCK) == 0:
					HUD.level.group.spectrum()
				else:
					HUD.level.entity[hero].animation.play_coma()
			elif a_points[hero] == 0 and i_points[hero] == 0:
				entity[hero].process_mode = Node.PROCESS_MODE_DISABLED
				entity[hero].animation.transport()
				var shift: int = -1 if randi_range(0, 1) == 0 else 1
				entity[hero].spawn_pos = posmod(entity[hero].spawn_pos + shift, len(places))
				entity[hero].position = HUD.level.spawn[entity[hero].state[2]]
		)
	if a != 0:
		if hero < Def.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.AURA, hero) + a, 0, a_max[hero])
			HUD.set_stat(HUD.AURA, hero, stat)
			for ui in _get_ui(): ui.aura.value = stat
		else:
			var h: int = hero - Def.PARTY
			a_points[h] = clampi(a_points[h] + a, 0, aura[h])
			if a <= 0:
				i_points[h] = 255
				HUD.game.ability.health.modulate = Color.WHITE
				HUD.game.ability.health.max_value = i_points[h]
				HUD.game.ability.health.value = i_points[h]
			else:
				HUD.game.ability.health.modulate = Color.GRAY
				HUD.game.ability.health.max_value = aura[h]
				HUD.game.ability.health.value = a_points[h]
	if r != 0:
		if hero < Def.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.RESOURCE, hero) + r, 0, r_max[hero])
			HUD.set_stat(HUD.RESOURCE, hero, stat)
			for ui in _get_ui(): ui.resource.value = stat
		else:
			r_points[hero] = clampi(r_points[hero] + r, 0, resc[hero])
		entity[hero].profile.material.set(&"shader_parameter/action", true)

enum { TARGET, ZONE_RADIUS, TARGET_RADIUS, ZONE_ALL,
	DISTANCE = 1024, RADIUS_DISTANCE = 4096 }
enum { VOID, LIGHT, NORMAL, FIRE, WATER, SPARK }

var dir: PackedVector2Array = []

func damage_zone(type: int, hero: int, element: int, combo: int, portion: float, output: float = 0) -> void:
	match type:
		ZONE_ALL:
			var start: int = Def.PARTY if hero < Def.PARTY else 0
			var xp: int = 0
			for i in range(start, entities):
				if hero != i:
					damage(hero, i, element, portion)
					xp += exper[i]
			if start == Def.PARTY and xp != 0:
				score_up(xp * combo)
		TARGET:
			damage_output(Def.T4 * dir[hero], DISTANCE, hero, element, combo, portion, output)
		TARGET_RADIUS:
			damage_output(Def.T8 * dir[hero], RADIUS_DISTANCE, hero, element, combo, portion, output)
		ZONE_RADIUS:
			damage_output(Vector2.ZERO, RADIUS_DISTANCE, hero, element, combo, portion, output)
	
func damage_output(direction: Vector2, distance: int, hero: int, element: int, combo: int, portion: float, output: float) -> void:
	var start: int = Def.PARTY if hero < Def.PARTY else 0
	var xp: int = 0
	for i in range(start, entities):
		if hero != i and (entity[hero].position + direction).distance_squared_to(entity[i].position) < distance:
			damage(hero, i, element, portion)
			entity[i].velocity += dir[hero] * Def.T8 * output
			xp += exper[i]
	if start == Def.PARTY and xp != 0:
		score_up(xp * combo)

enum { LOW = 128, MID1 = 172, MID = 196, MID2 = 214, HIGH = 256 }

func damage_throw(hero: int, box: int, direction: Vector2, element: int) -> void:
	var start: int = Def.PARTY if hero < Def.PARTY else 0
	var check: Rect2 = Rect2(entity[box].position + LOW * direction, entity[box].position + HIGH * direction)
	var ideal: Rect2 = Rect2(entity[box].position + MID1 * direction, entity[box].position + MID2 * direction)
	
	for i in range(start, entities):
		var delta: Vector2 = entity[box].position + entity[i].position * direction
		if hero != i and delta >= check.position and check.size <= delta:
			var fight: int = power[hero]
			var contr: int = shell[i]
			if element != NORMAL:
				fight = (fight >> 1) + (impac[hero] >> 1)
				contr = (contr >> 1) + (react[i] >> 1)
			
			var portion: float = 1.0
			if delta >= ideal.position and ideal.size <= delta:
				portion = 1.5
				
			if weakn[i] == element:
				affect(i, min((contr >> 1) - fight * portion, -10 * portion), 0)
			elif immun[i] == element:
				affect(i, min((contr << 1) - fight * portion, -10 * portion), 0)

func damage(hero: int, enemy: int, element: int, portion: float) -> void:
	var fight: int = impac[hero]
	var contr: int = react[enemy]
	if element == NORMAL:
		fight = power[hero]
		contr = shell[enemy]
	fight = int(fight * portion)
	if element == LIGHT:
		affect(enemy, contr >> 1 + fight, 0)
	elif weakn[enemy] == element:
		affect(enemy, min(contr >> 1 - fight, -1), 0)
	elif immun[enemy] == element:
		affect(enemy, min(contr << 1 - fight, -1), 0)
	else:
		affect(enemy, min(contr - fight, -1), 0)

var places: PackedInt32Array
var place_size: int = 0
var min_enemy: PackedByteArray = [0, 1, 2, 3, 4]
var max_enemy: PackedByteArray = [0, 3, 5, 9, 12]
const foe: Array[PackedScene] = [
	preload("res://def/entity/foe/eye_seeker.tscn"),
	preload("res://def/entity/foe/eye_seeker.tscn")
]

enum { DIFFICULTY = 1, FROM = 0, UPTO = 1 }

func teleport(enemy: CharacterBody2D) -> void:
	enemy.spawn_pos = (enemy.spawn_pos + 1) % places.size()
	enemy.position = HUD.level.execute.get_pos(places[enemy.spawn_pos])

func reload() -> void:
	if max_enemy[DIFFICULTY] == 0: return
	
	var pos: PackedVector2Array = HUD.level.tags.layer.get_used_cells_by_id(4)
	place_size = 0
	for i in len(pos):
		if i < places.size():
			places[i] = Def.join(pos[i])
		else:
			places.append(Def.join(pos[i]))
		place_size += 1
		
	entities = Def.PARTY
	var count: int = randi_range(min_enemy[DIFFICULTY], max_enemy[DIFFICULTY])
	for i in range(0, foe.size()):
		if Def.of(HUD.level.foe, i):
			for c in mini(count * HUD.level.portion[i], 1):
				entity[entities] = foe[i].instantiate()
				entity[entities].no = entities
				HUD.level.border.layer.add_child(entity[entities])
				a_points[entities - Def.PARTY] = aura[entities]
				r_points[entities - Def.PARTY] = resc[entities]
				a_portion[entities] = 1.0 / aura[entities]
				r_portion[entities] = 1.0 / resc[entities]
				entity[entities].position = Def.map(places[randi_range(0, place_size)])
				entities += 1

enum { MAX_LV = 7, PRIORITY_SELECT = 7, SCORE_HALF = 1,
	PURSUIT = 0, SELF_CONTROL = 1, TENACITY = 2, SELECT = 3, SCORE_BIT = 24 }

var level: int
var next: PackedInt32Array = [6, 12, 27, 50, 80, 115, 154,  200, 265, 340, 430,
	537, 650, 775,  900, 1040, 1220, 1420, 1667, 1960, 2333]

func bonus(add: int, x: float) -> void: score_up(roundi(add * x))

func score_up(add: int) -> void:
	var score: int = (HUD.get_half(HUD.SCORE, SCORE_HALF) & (Def.bit(SCORE_BIT) - 1)) + add
	if level < next.size() and score >= next[level]:
		var before: int = level
		while level < next.size() and score >= next[level]: level += 1
		var after: int = level
		var selection: int = HUD.get_part(HUD.SCORE, PRIORITY_SELECT)
		for hero in range(0, Def.PARTY):
			var priority: Vector3i = Vector3i(
				HUD.get_part(HUD.PRIORITY, PURSUIT * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, SELF_CONTROL * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, TENACITY * HUD.HALF + hero))
			var select: int = Def.of_x(Def.MASK2, selection, hero)
			var delta: int = after - before
			
			if hero == HUD.hero: HUD.game.ability.priority[select].background = Color.GRAY
			
			while delta != 0:
				if priority[select] + delta <= MAX_LV:
					priority[select] += delta
					delta = 0
				else:
					delta -= MAX_LV - priority[select]
					select = (select + 1) % SELECT
			
			if hero == HUD.hero: HUD.game.ability.priority[select].background = Color.WHITE
			
		for xp in [HUD.game.ability, HUD.game.priorities]:
			if level < next.size():
				xp.bar.max_value = next[level]
	for xp in [HUD.game.ability, HUD.game.priorities]:
		xp.bar.value = next[level]
		xp.score.text = str(next[level])

enum { COOL, RECOVER, RESTORE }

var station_cooldown: bool = false

func enter_cooldown() -> void:
	station_cooldown = false

func enter_station(hero: int, no: int) -> void:
	if station_cooldown: return
	station_cooldown = true
	HUD.station_timer.start()
	match no:
		COOL: HUD.game.log.append_text("SOME TEST")
		RECOVER: affect(hero, +5, 0)
		RESTORE: affect(hero, 0, +3)
