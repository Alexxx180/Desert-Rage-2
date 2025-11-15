extends VBoxContainer

@onready var caption: HBoxContainer = $caption
@onready var stats: MarginContainer = $stats
@onready var priority: HBoxContainer = $hero

func set_stats(summary: Dictionary, no: int, at: int) -> void:
	var hero: Dictionary = summary.hero[name]
	hero.of[hero.at]
	
	caption.set_priority(no, at)
	stats.set_stats(stats)
	priority.set_next_priority(caption.priorities[no])
