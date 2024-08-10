extends Node

const GAP: int = 2

var previous: Vector2
var entity: Node2D

func set_control_entity(box: Node2D):
	entity = box
	remember_position()

func remember_position():
	previous = entity.position

func rollback_position():
	entity.position = previous

func push(axis: int, velocity: int):
	remember_position()
	entity.position[axis] += velocity
