extends Node

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
