class_name PlayerXP extends RefCounted

var multiply: Timer
var priority: PlayerXP = PlayerXP.new()
var summary: Dictionary = MakeStats.summary()
var prev: Dictionary = summary

func _init(timer: Timer) -> void:
	multiply = timer
	remember_progress() # func sync_points(hero: String, kind: String, value: int) -> void: summary.hero[hero].points[kind] = value

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

func level_up(i: Dictionary) -> void: i.of[i.at] += 1
