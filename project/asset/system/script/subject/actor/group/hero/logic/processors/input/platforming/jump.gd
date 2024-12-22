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
	_jump(true, feet.deployment.walls.current.position, dash)

func _to_ledge() -> void:
	#print("teleported")
	_jump(false, ledges.current.get_ledge_position(), teleport)

func floor_only(control: Node, _gap: TileMapLayer) -> void:
	if feet.can_land(overview):
		print("can jump")
		_to_floor()
	else:
		print("can't jump")
	control.available = false

func _set_midair(control: Node, is_in_midair: bool) -> void:
	control.available = is_in_midair
	overview.height.freeze = is_in_midair

func determine(control: Node, upland: TileMapLayer) -> void:
	print("upland encounter: jump determine")
	var up: TileMapLayer = upland if upland.name == "border" else upland.floors

	if ledges.around(overview, feet):
		_to_ledge()
	elif feet.can_deploy(up, overview):
		_to_floor()
	else:
		print("No jump, upland: ", upland.name)

	_set_midair(control, feet.balance.unstable)
