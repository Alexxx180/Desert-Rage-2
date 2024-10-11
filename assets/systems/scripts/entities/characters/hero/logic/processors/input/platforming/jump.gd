extends Node

signal teleport(position: Vector2)
signal dash(position: Vector2)

@onready var overview: Node = $overview
@onready var ledges: Node = $ledges
@onready var feet: Node = $feet

func _jump(to_floor: bool, next: Vector2, move) -> void:
	move.emit(next)
	feet.balance.stable = to_floor

func _to_floor() -> void:
	_jump(true, feet.deployment.ground.position, dash)

func _to_ledge() -> void:
	_jump(false, ledges.current.get_ledge_position(), teleport)

func floor_only(control: Node, _gap: TileMapLayer) -> void:
	if feet.free_space(overview):
		_to_floor()
	control.available = false

func determine(control: Node, upland: TileMapLayer) -> void:
	print("YEEAH: ", upland.name)
	if ledges.around(overview):
		print("TO LEDGE")
		_to_ledge()
	elif feet.can_deploy(upland.floors, overview):
		print("TO FLOOR")
		_to_floor()
	print("CAN DEP? ", feet.can_deploy(upland.floors, overview))
	print("JUMP PERFORMED")
	control.available = feet.balance.unstable
