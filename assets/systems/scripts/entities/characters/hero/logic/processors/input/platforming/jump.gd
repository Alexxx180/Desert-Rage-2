extends Node

signal move(position: Vector2)
signal disable()

@onready var overview: Node = $overview
@onready var ledges: Node = $ledges
@onready var feet: Node = $feet

func _jump(to_floor: bool, next: Vector2) -> void:
	feet.stable = to_floor
	move.emit(next)
	if feet.stable: disable.emit()

func determine() -> bool:
	if ledges.around(overview):
		_jump(false, ledges.current.pos)
	elif feet.same_level(overview):
		_jump(true, feet.deployment.position)
	return feet.unstable
