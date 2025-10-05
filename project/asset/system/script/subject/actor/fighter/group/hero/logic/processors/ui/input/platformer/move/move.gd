extends Node

@onready var act: Node = $act
@onready var device: Node = $device

func _ready() -> void:
	device.keyboard.act = act
	device.mouse.device = device

var hero: CharacterBody2D:
	set(value):
		device.mouse.hero = value
		act.velocity.hero = value
		act.teleport.hero = value
