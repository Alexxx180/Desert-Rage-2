extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help

func controls(hud: Control, margin: MarginContainer) -> void:
	pause.controls(hud, margin.pause)
	help.controls(hud, margin.hints.analyze)
