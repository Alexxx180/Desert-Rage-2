extends Resource

class_name EntityStats

signal impulse(power: int)
signal new_mach(mach: int)
signal run(speed: int)

const STEP: int = 1000

@export_range(0, 255) var push: int = 2
@export_range(0, 255) var speed: int = 33 # 20

func apply_impulse(mach: int) -> void:
	impulse.emit(mach * push)

func accelerate(mach: int) -> void:
	apply_impulse(mach)
	new_mach.emit(mach)
	run.emit(mach * speed * STEP)
