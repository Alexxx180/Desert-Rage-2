extends RefCounted

class_name MakeStats

enum { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3, HP = 4, AP = 5 }

const PRIORITY: Array[Array] = [[3, 2, 1, 1], [1, 3, 1, 2], [1, 1, 3, 2]]

static func _points(stats: Array, add: Array, pts: Array) -> void:
	stats[pts[0]] += add[pts[1]] * 2 + add[pts[2]]

static func stats(stats: Array, priority: Vector2i) -> void:
	var add: Array = PRIORITY[priority.x]
	for i in range(POWER, HP):
		stats[i] += add[i] * priority.y
	for i in [[HP, VITALITY, POWER], [AP, REACTION, INFLUENCE]]:
		_points(stats, add, i)

static func delta(current: Dictionary, previous: Dictionary) -> void:
	for stat in range(POWER, AP):
		previous[stat] = current[stat] - previous[stat]

static func summary() -> Dictionary:
	return {
		"xp": 0, "hero": {
			"ray": { "at": 0, "of": [0, 0, 0], "stat": { "h": 9, "a": 11, "buff": [] }, },
			"rock": { "at": 0, "of": [0, 0, 0], "stat": { "h": 11, "a": 9, "buff": [] } },
		}
	}
