extends Node

@onready var multiply: Node = $multiply
@onready var priority: Node = $priority
@onready var summary: Dictionary = MakeStats.summary()
@onready var prev: Dictionary = summary

func _ready() -> void: remember_progress() # func sync_points(hero: String, kind: String, value: int) -> void: summary.hero[hero].points[kind] = value

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
