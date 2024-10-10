extends Node

@onready var directions: Node = $directions
@onready var height: Node = $height

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		print(" - AXIS: ", axis)
		try = try and directions.observe(axis, ledge)
		print("TRY: ", try)
	return try

func reach(stand: Area2D) -> bool:
	var seat: Node = stand.box.logic.processors.movement.seat
	var pos: Vector2 = stand.box.position #  stand.get_ledge_position()

	print("SEAT READY: ", not seat.place.stand())
	return not seat.place.stand() and _observe(pos)
