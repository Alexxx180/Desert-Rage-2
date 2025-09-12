extends Node

signal update_stats(stats: Dictionary)

const STATS: int = 4
const BASE: Dictionary = { "ray": [1, 2, 0, 2], "rock": [2, 1, 1, 1] }
const PRIORITY: Array[Array] = [[3, 2, 1, 1], [1, 3, 1, 2], [1, 1, 3, 2]]

func set_stats(stats: Array, priority: Vector2i) -> void:
	var add: Array = PRIORITY[priority.x]
	for i in range(0, STATS):
		stats[i] += add[i] * priority.y

func make_priorities(priorities: Array, stats: Array) -> void:
	for i in range(0, len(priorities)):
		set_stats(stats, Vector2i(i, priorities[i]))

func calculate(heroes: Dictionary) -> void:
	var stats: Dictionary = {}
	for hero in BASE:
		stats[hero] = BASE[hero].duplicate()
		make_priorities(heroes[hero].of, stats[hero])
	update_stats.emit(stats)
