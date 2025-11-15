extends MarginContainer

@onready var add: MarginContainer = $add
@onready var next: MarginContainer = $nex

func set_stats(stats: Dictionary) -> void:
	add.set_stats(stats)
	next.set_stats(stats)
