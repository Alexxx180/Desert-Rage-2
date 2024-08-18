extends Node

@onready var size = $size
@onready var speed = $speed
@onready var mach = $mach
@onready var push = $push

func set_control_entity(hero: CharacterBody2D) -> void:
	size.set_control_entity(hero)

func impulse() -> float: return mach.value * push.value

func run(input: Node) -> Vector2:
	return input.direction * mach.value * speed.value

func set_mach(increase: Array[int], x: Node, y: Node) -> void:
	mach.value = 1
	for plane in [x, y]: mach.value *= increase[plane.axis]
	print("CURRENT MACH: ", mach.value)
