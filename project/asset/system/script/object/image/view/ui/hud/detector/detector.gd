extends Control

@onready var game: Control = $game
var pause: Control

func set_pause() -> void:
	pause = load("res://asset/system/scene/object/canvas/ui/hud/detector/pause/pause.tscn").instantiate()
