extends Node

@onready var act: Node = $act
@onready var device: Node = $device

func _ready() -> void:
	device.move.connect(act.turn_around)
	device.mouse.manual.act = act

var hero: CharacterBody2D:
	set(value):
		device.mouse.target.hero = value
		act.velocity.hero = value
		act.teleport.hero = value
