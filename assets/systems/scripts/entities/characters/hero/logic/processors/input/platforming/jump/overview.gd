extends Node

@onready var directions: Node = $directions
@onready var height: Node = $height

var _id: int = -1

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and directions.observe(axis, ledge)
	return try

func reach(stand: Area2D) -> bool:
	var seat: Node = stand.box.logic.processors.movement.seat
	var pos: Vector2 = stand.box.position #  stand.get_ledge_position()
	var next: int = stand.get_instance_id()
	var same: bool = _id == next # directions.eyes.direction == Vector2i.ZERO
	print("SAME: ", same)
	print("DIR: ", directions.eyes.direction)

	var result = not same and not seat.place.stand() and _observe(pos)
	if (result): _id = next

	return result
