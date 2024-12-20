extends Node

@onready var game: Node = $game
@onready var pause: Node = $pause

func controls(hud: Control) -> void:
	var margin: MarginContainer = hud.detector.game.margin
	
	game.controls(hud, hud.detector.game.margin)
	pause.controls(hud, hud.detector.pause.options.menu)
