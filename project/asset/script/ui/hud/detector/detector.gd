extends Control

@onready var game: Control = $game
var pause: Control

func set_pause() -> void:
	pause = load(LoadBus.hud % "pause").instantiate()
