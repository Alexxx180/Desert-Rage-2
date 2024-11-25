extends Node

@onready var floors: Node = $floors
@onready var seat: Node = $seat
@onready var push: Node = $push

func controls(box: CharacterBody2D, movement: Node) -> void:
	floors.controls(box, movement.floors)
	seat.controls(box, movement.seat)
	push.controls(box, movement.push)
