extends MarginContainer

@onready var offence: VBoxContainer = $stats/offence
@onready var defence: VBoxContainer = $stats/defence
@onready var points: VBoxContainer = $stats/points

func set_stats(stats: Dictionary) -> void:
	for type in ["offence", "defence", "points"]:
		get(type).set_stats(stats) # [type]
