extends Node

signal impulse(power: int)
signal run(speed: int)

@onready var size = $size
@onready var speed = $speed
@onready var push = $push

func set_control_entity(hero: CharacterBody2D) -> void:
	size.set_control_entity(hero)

func accelerate(mach: int) -> void:
	impulse.emit(mach * push.value)
	run.emit(mach * speed.value)
