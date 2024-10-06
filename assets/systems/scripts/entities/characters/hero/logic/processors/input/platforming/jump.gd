extends Node

signal move(position: Vector2)

@onready var overview: Node = $overview
@onready var ledges: Node = $ledges
@onready var feet: Node = $feet

func _jump(to_floor: bool, next: Vector2) -> void:
	move.emit(next)
	feet.balance.stable = to_floor

func _to_floor() -> void: _jump(true, feet.deployment.position)
func _to_ledge() -> void: _jump(false, ledges.current.pos)

func floor_only(_floors: TileMapLayer) -> bool:
	if feet.free_space(overview):
		_to_floor()
	return feet.balance.unstable

func determine(floors: TileMapLayer) -> bool:
	if ledges.around(overview):
		_to_ledge()
	elif feet.can_deploy(floors, overview):
		_to_floor()
	return feet.balance.unstable
