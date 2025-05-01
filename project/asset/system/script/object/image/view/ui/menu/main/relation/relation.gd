extends Node

@onready var remember: Node = $remember
@onready var new: Node = $new
@onready var exit: Node = $exit

func controls(hud: Control, processor: Node) -> void:
	remember.controls(hud, processor.remember)
	new.controls(hud, processor.new)
	exit.controls(hud, processor.exit)
