extends Resource

class_name EntityStats

signal new_mach(mach: int)

enum { STEP = 1000, PUSH = 64 }

@export_range(10, 64) var push: int = 2
@export_range(10, 255) var run: int = 33 # 20

var _mach: int = 1
var speed: float = 0
var force: float = 0

func update_stats():
	speed = _mach * STEP * run
	force = _mach * STEP * push

func accelerate(mach: int) -> void:
	new_mach.emit(mach)
	_mach = mach
	update_stats()
