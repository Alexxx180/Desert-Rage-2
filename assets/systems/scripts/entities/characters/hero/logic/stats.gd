extends Node

signal impulse(power: int)
signal run(speed: int)

const FRICTION: float = 0.002

@onready var size: Node = $size
@onready var speed: Node = $speed
@onready var push: Node = $push

func accelerate(mach: int) -> void:
	impulse.emit(mach * push.value * FRICTION)
	run.emit(mach * speed.value)
