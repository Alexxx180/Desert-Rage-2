extends Node

@onready var resume: Node = $resume
@onready var settings: Node = $settings
@onready var exit: Node = $exit
@onready var hints: Node = $hints

func controls(hud: CanvasLayer, menu: VBoxContainer) -> void:
	resume.controls(hud, menu.resume)
	settings.controls(hud, menu.settings)
	exit.controls(hud, menu.exit)
	hints.controls(hud)
