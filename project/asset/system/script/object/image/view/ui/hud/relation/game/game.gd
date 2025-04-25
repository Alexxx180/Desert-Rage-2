extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help

func controls(hud: CanvasLayer, options: HBoxContainer) -> void:
	pause.controls(hud, options.pause)
	help.controls(hud, options.analyze)
