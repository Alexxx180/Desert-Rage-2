extends Node

signal update_stats()
signal update_exp(value: int, max: int)

const MAX_LV: int = 7
const NEXT: float = 1.5

var summary: Dictionary

func sync_points(hero: String, kind: String, value: int) -> void:
	summary.priorities[hero].points[kind] = value

func level_up() -> void:
	summary.next *= NEXT
	for hero in summary.priorities:
		var i: Dictionary = summary.priorities[hero]
		i.of

func _circle_level_up() -> void:
	while summary.xp >= summary.next:
		lv += 1
		summary.next *= 1.5
		for hero in summary.priorities:
			var i = 
			summary.priorities[hero].of
	summary

func add_exp(amount: int) -> void:
	summary.xp += amount
	if summary.xp >= next:
		_circle_level_up()
		upate_stats.emit()
	update_exp.emit(summary.xp, summary.next)

func _ready() -> void:
	deploy.init(self, [$ray, $rock], deployed)
	if is_overworld: camera.set_overworld()
	summary = {
		"xp": 0, "next": 10, "priorities": {
			"ray": { "at": 0, "of": [0, 0, 0], "points": { "h": 9, "a": 11 }, },
			"rock": { "at": 0, "of": [0, 0, 0], "points": { "h": 11, "a": 9 } },
		}
	}
	for hero in deploy.party.heroes:
		hero.logic.processors.stats.summary = summary
