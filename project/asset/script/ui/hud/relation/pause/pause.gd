extends Node

@onready var resume: Node = $resume
@onready var information: Node = $information
@onready var settings: Node = $settings
@onready var exit: Node = $exit
@onready var hints: Node = $hints

func controls(hud: CanvasLayer, menu: HFlowContainer) -> void:
	resume.controls(hud, menu.resume)
	information.controls(hud, menu.information)
	settings.controls(hud, menu.settings)
	exit.controls(hud, menu.exit)
	hints.controls(hud)
	var pause: Control = hud.see.pause
	pause.visibility_changed.connect(func():
		if pause.visible: pause.options.menu.focused = false
	)
