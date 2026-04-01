extends RefCounted

class_name MakeStats

enum STAT { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3, HP = 4, AP = 5, MAX = 6 }
enum PRIORITIES { PURSUIT = 0, SELF_CONTROL = 1, TENACITY = 2 }

const PRIORITY: Array[Array] = [[3, 2, 1, 1], [1, 3, 1, 2], [1, 1, 3, 2]]
const BASE: Dictionary = { "ray": [1, 2, 0, 2, 100, 20], "rock": [2, 1, 1, 1, 100, 20] } # ray, p: 5, 5  rock, p: 7, 3

var level: LevelUpXP

func _init(multiply: Timer) -> void:
	level = LevelUpXP.new(multiply)

func make_priorities(priorities: Array, values: Array) -> void:
	for i in range(0, len(priorities)):
		MakeStats.stats(values, Vector2i(i, priorities[i]))

func calculate(heroes: Dictionary) -> Dictionary:
	var values: Dictionary = {}
	for hero in BASE:
		values[hero] = BASE[hero].duplicate()
		make_priorities(heroes[hero].of, values[hero])
	return values

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
