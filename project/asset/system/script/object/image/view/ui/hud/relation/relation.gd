extends Node

#@onready var screen: Node = $screen
#@onready var help: Node = $help
#@onready var pause: Node = $pause

func _set_help(hud: Control, button: Button) -> void:
	var content: Control = button.get_node("content/help")
	var hint: Node = hud.processor.help

	button.toggled.connect(hint.show_help)
	button.pressed.connect(hud.detector.get_node("game/hints/motion").toggle_hints)

	hint.state = content.get_node("mode/state")
	hint.short = content.get_node("short")
	hint.show_help(true)

func _set_resume(hud: Control) -> void:
	var ui: MarginContainer = hud.detector
	var suspend: Node = hud.processor.suspend

	for pause in ["game/pause", "pause/menu/resume"]:
		ui.get_node(pause).pressed.connect(suspend.toggle_pause)

	suspend.game = ui.get_node("game")
	suspend.pause = ui.get_node("pause")

func _set_screen(hud: Control, button: Button) -> void:
	var content: Control = button.get_node("content/window")
	var screen: Node = hud.processor.screen

	button.toggled.connect(screen.toggle)

	screen.state = content.get_node("mode")
	screen.short = content.get_node("short")

func controls(hud: Control) -> void:
	var menu: VBoxContainer = hud.detector.get_node("pause/menu")

	_set_resume(hud)
	_set_screen(hud, menu.get_node("screen"))
	_set_help(hud, menu.get_node("help"))
