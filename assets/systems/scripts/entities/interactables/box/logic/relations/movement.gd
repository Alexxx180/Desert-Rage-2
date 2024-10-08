extends Node

@onready var surface: Node = $surface
@onready var seat: Node = $seat
@onready var push: Node = $push

func set_control(box: StaticBody2D, movement: Node) -> void:
	surface.set_control(box, movement.surface)
	seat.set_control(box, movement.seat)
	push.set_control(box, movement.push)
