extends Node

@onready var screen: Node = $screen
@onready var help: Node = $help
@onready var pause: Node = $pause
@onready var hints: Node = $hints

func controls(hud: Control) -> void:
	var menu: VBoxContainer = hud.detector.get_node("pause/margin/stretch/pause/menu")

	pause.controls(hud)
	screen.controls(hud, menu.get_node("screen"))
	help.controls(hud, menu.get_node("help"))
	hints.controls(hud)
