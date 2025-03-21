extends Node2D

@export var distance: Vector2 = Vector2(114, 114)
@export var offset: Array[int] = [-28, 28, 0]

@onready var center: ShapeCast2D = $center
@onready var walls: Array[ShapeCast2D] = [$left, $right, center]
@onready var last_pos: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
@onready var _half: Vector2 = center.shape.size / 2

func set_direction(direction: Vector2) -> void:
	var i: int = offset.size()
	
	position = direction * (distance + _half)
	var norm: Vector2 = position.orthogonal().normalized()
	
	while i > 0:
		i -= 1
		var pos: Vector2 = norm * offset[i]
		walls[i].position = pos
		if pos != Vector2.ZERO:
			last_pos[i] = pos
