extends Node

@onready var directions: Node = $directions
@onready var height: Node = $height

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and directions.observe(axis, ledge)
	return try

func reach(stand: Area2D, feet: Node) -> bool:
	var pos: Vector2 = stand.get_ledge_position()
	var seat: Node = stand.seat
	#var seat: Node = stand.box.logic.processors.movement.seat

	return (not seat.place.stand() and _observe(pos)
		and feet.same_level(self, seat.F))
