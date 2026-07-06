extends Node

@onready var mode: Node = $mode
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _input(event: InputEvent) -> void:
	if mode.type.listen():
		mode.manage(get(mode.device.named), event)
