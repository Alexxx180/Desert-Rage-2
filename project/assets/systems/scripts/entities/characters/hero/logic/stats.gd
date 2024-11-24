extends Node

signal impulse(power: int)
signal new_mach(mach: int)
signal run(speed: int)

@onready var size: Node = $size
@onready var speed: Node = $speed
@onready var push: Node = $push

func apply_impulse(mach: int) -> void:
	impulse.emit(mach * push.value)

func accelerate(mach: int) -> void:
	apply_impulse(mach)
	new_mach.emit(mach)
	run.emit(mach * speed.value)
