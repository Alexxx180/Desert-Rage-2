extends Node

@onready var size = $size
@onready var speed = $speed
@onready var mach = $mach
@onready var push = $push

func set_control_entity(hero: CharacterBody2D) -> void:
	size.set_control_entity(hero)

func accelerate(next: int) -> void:
	mach.value = next

func impulse() -> float:
	return mach.value * push.value

func run(direction: Vector2i) -> Vector2:
	return direction * mach.value * speed.value
