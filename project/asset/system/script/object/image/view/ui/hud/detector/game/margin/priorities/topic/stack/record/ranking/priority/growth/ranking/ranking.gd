extends HBoxContainer

@onready var rank: MarginContainer = $rank
@onready var title: VBoxContainer = $title

var status: VBoxContainer

func calculate_rank() -> void:
	pass # implement based on enemy and hero stats
