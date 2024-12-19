extends Node

@onready var screen: Node = $screen
@onready var help: Node = $help
@onready var pause: Node = $pause
@onready var hints: Node = $hints
@onready var exit: Node = $exit

func controls(hud: Control) -> void:
	var menu: VBoxContainer = hud.detector.get_node("pause/margin/stretch/pause/menu")

	pause.controls(hud)
	hints.controls(hud)
	screen.controls(hud, menu.get_node("screen"))
	help.controls(hud, menu.get_node("help"))
	exit.controls(hud, menu.get_node("exit"))
