class_name MakeStats extends RefCounted

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
