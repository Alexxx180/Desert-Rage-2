extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory

func controls(hud: CanvasLayer, game: Control) -> void:
	pause.controls(hud, game.options.pause)
	help.controls(hud, game)
	gameplay.controls(hud, game.options)
	inventory.controls(hud, game.get_node("menu/stats/inventory"))
