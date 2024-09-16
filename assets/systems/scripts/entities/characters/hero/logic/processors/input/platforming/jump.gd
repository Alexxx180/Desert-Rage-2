extends Node

signal move(position: Vector2)
signal disable()

var F: int = 0
var deployment: Vector2 = Vector2.ZERO

@onready var overview: Node = $overview
@onready var ledges: Node = $ledges
@onready var feet: Node = $feet

func _floors(number: int, position: Vector2) -> void:
	F = number
	deployment = position

func _jump(to_floor: bool, next: Vector2) -> void:
	feet.stable = to_floor
	move.emit(next)
	if feet.stable: disable.emit()

func determine() -> bool:
	if ledges.around(overview):
		_jump(false, ledges.current.pos)
	elif F != 0 and F == overview.surface.F:
		_jump(true, deployment) # print("Jump from ", overview.surface.F, " floor to ", F)
	return feet.unstable
