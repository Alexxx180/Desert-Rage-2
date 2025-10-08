extends Node

@onready var act: Node = $act
@onready var device: Node = $device

func _ready() -> void:
	device.keyboard.act = act
	device.mouse.act = act
