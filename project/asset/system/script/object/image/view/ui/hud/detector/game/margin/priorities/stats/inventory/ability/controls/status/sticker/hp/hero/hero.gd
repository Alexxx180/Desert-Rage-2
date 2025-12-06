extends ProgressBar

@onready var health: MarginContainer = $health
@onready var ailments: HBoxContainer = $status/ailments

func change(hp: Node) -> void:
	value = hp.points
	health.change(hp)
