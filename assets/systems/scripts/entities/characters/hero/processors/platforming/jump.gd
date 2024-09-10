extends Node

signal move(position: Vector2)
signal disable()

var F: int = false
var deployment: Vector2 = Vector2.ZERO

@onready var overview: Node = $overview
@onready var ledges: Node = $ledges
@onready var feet: Node = $feet

func _floors(number: int, position: Vector2):
	F = number
	deployment = position

func _jump(to_floor: bool, next: Vector2):
	feet.stable = to_floor
	move.emit(next)
	if feet.stable: disable.emit()

func determine():
	if ledges.around(overview):
		_jump(false, ledges.current.pos)
	elif F != 0 and F == overview.surface.F:
		print("Jump from ", overview.surface.F, " floor to ", F)
		_jump(true, deployment)
