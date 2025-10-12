extends Node

@onready var push: Node = $push
@onready var seat: Node = $seat
@onready var floors: Node = $floors
@onready var gravity: Node = $gravity

func apply_velocity(next: Vector2) -> void: push.apply_velocity(next)

func throw_velocity(power: int) -> void: push.throw_velocity(power)
