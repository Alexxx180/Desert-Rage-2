extends Node

@onready var resume: Node = $resume
@onready var screen: Node = $screen
@onready var exit: Node = $exit
@onready var hints: Node = $hints

func controls(hud: Control, menu: VBoxContainer) -> void:
	resume.controls(hud, menu.resume)
	screen.controls(hud, menu.screen)
	exit.controls(hud, menu.exit)
	hints.controls(hud)
