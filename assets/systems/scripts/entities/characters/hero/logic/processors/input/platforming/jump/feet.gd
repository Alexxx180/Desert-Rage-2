extends Node

signal set_movement(is_floor: bool)

@onready var deployment: Node = $position
@onready var height: Node = $height

var unstable: bool:
	get: return not _stable

var _stable: bool = true
var stable: bool: get = _is_stable, set = set_stable

func _is_stable() -> bool: return _stable

func set_stable(is_floor: bool) -> void:
	if (is_floor != _stable):
		set_movement.emit(is_floor)
	_stable = is_floor

func placement(f: int, next: Vector2) -> void:
	height.set_floor(f)
	deployment.set_position(next)

func same_level(overview: Node) -> bool:
	return height.F != 0 and height.F == overview.height.F
