extends MarginContainer

@onready var offence: VBoxContainer = $stats/offence
@onready var defence: VBoxContainer = $stats/defence
@onready var points: VBoxContainer = $stats/points

func _reveal(feedback: Callable) -> void:
	for type in ["offence", "defence", "points"]:
		feedback.call(get(type))

func set_stats(stats: Dictionary) -> void:
	_reveal(func(t): t.set_stats(stats))

func reveal_stats() -> void:
	_reveal(func(t): t.reveal_stats())
