extends Node

@onready var game: Node = $game
@onready var pause: Node = $pause

func controls(hud: CanvasLayer) -> void:
	game.controls(hud, hud.detector.game.options)
	pause.controls(hud, hud.detector.pause.options.menu)
