extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory

func controls(hud: CanvasLayer, options: HFlowContainer) -> void:
	pause.controls(hud, options.pause)
	help.controls(hud, options.analyze)
	gameplay.controls(hud, options)
	inventory.controls(hud, hud.detector.game.get_node("menu/stats/inventory"))
