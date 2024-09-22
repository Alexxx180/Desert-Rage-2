extends Node

@onready var platforming: Node = $platforming
@onready var seat: Node = $seat

func set_control(box: StaticBody2D, movement: Node) -> void:
	platforming.set_control(box, movement.platforming)
	seat.set_control(box, movement.seat)
