extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help

func controls(hud: Control, options: HBoxContainer) -> void:
	pause.controls(hud, options.pause)
	help.controls(hud, options.analyze)
