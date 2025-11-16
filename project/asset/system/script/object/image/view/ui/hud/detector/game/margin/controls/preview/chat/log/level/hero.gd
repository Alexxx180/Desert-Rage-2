extends HBoxContainer

@onready var priority: VBoxContainer = $priority
@onready var stats: VBoxContainer = $stats

func _ready() -> void: stats.hero.set_caption(name)

func set_priority(level: Node, numbers: Dictionary) -> void:
	var hero: Dictionary = level.summary.hero[name]
	var prev: Dictionary = level.prev.hero[name]
	if hero.at != prev.at:
		stats.hero.set_next_priority(priority.names[hero.at])
	priority.set_priority(prev.at, hero.of[prev.at])
	stats.number.set_stats(numbers.stats[name], numbers.prev[name])
