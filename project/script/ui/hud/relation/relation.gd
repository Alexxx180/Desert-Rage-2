extends Node

@onready var game: Node = $game
# @onready var pause: Node = $pause

func controls(hud: CanvasLayer) -> void:
	game.controls(hud, hud.see.game)
	# pause.controls(hud, hud.see.pause.options.menu) TODO LOAD PAUSE
