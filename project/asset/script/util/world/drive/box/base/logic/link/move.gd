extends Node

@onready var seat: Node = $seat
@onready var push: Node = $push

func controls(box: CharacterBody2D, move: Node) -> void:
	seat.controls(box, move.seat)
	push.controls(box, move.push)
	move.gravity.box = box
