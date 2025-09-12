extends Node

signal update_exp(value: Vector2i, base: int)

enum { PRIORITY = 3, MAX_LV = 7, BASE_NEXT = 10 }

const MULTIPLIER: float = 1.2

@onready var stats: Node = $stats

var next: int
var base_xp: int
var summary: Dictionary

func sync_points(hero: String, kind: String, value: int) -> void:
	summary.hero[hero].points[kind] = value

func level_up(hero: String) -> void:
	var i: Dictionary = summary.hero[hero]
	var maxed: int = 0
	i.of[i.at] += 1
	while i.of[i.at] >= MAX_LV and maxed < PRIORITY:
		maxed += 1
		i.at = (i.at + 1) % PRIORITY
	_prevent_new_levels(maxed)

func _prevent_new_levels(maxed: int) -> void:
	if maxed == PRIORITY: next = 0

func _circle_level_up() -> void:
	while summary.xp >= next:
		summary.xp -= next
		for hero in summary.hero: level_up(hero)
		next_level()

func sync() -> void:
	sync_exp()
	sync_stats()

func sync_stats() -> void:
	stats.calculate(summary.hero)

func sync_exp() -> void:
	update_exp.emit(Vector2i(summary.xp, next), base_xp)

func add_exp(amount: int) -> void:
	summary.xp += amount
	if next != 0 and summary.xp >= next:
		_circle_level_up()
		sync_stats()
	sync_exp()

func next_level() -> void:
	next *= MULTIPLIER
	base_xp += next

func _remember_priority_as_max(i: int) -> bool:
	var priority: int = summary.hero.ray.of[i]
	for j in range(0, priority): next_level()
	return priority == MAX_LV

func _remember_progress() -> void:
	base_xp = 0
	next = BASE_NEXT
	var maxed: int = 0
	for i in range(0, PRIORITY):
		if _remember_priority_as_max(i): maxed += 1
	_prevent_new_levels(maxed)

func _ready() -> void:
	summary = {
		"xp": 0, "hero": {
			"ray": { "at": 0, "of": [0, 0, 0], "stat": { "h": 9, "a": 11, "buff": [] }, },
			"rock": { "at": 0, "of": [0, 0, 0], "stat": { "h": 11, "a": 9, "buff": [] } },
		}
	}
	_remember_progress()
