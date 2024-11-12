extends Node

@onready var directions: Node = $directions
@onready var height: Node = $height

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and directions.observe(axis, ledge)
	return try

func reach(stand: Area2D) -> bool:
	var seat: Node = stand.box.logic.processors.movement.seat
	var box: Vector2 = stand.box.position
	return not seat.place.stand() and _observe(box)
