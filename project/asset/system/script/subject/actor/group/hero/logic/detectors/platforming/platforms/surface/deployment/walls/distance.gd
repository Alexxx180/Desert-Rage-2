extends Node2D

@export var distance: Vector2 = Vector2(114, 114)
@export var offset: Array[int] = [-32, 32, 0]

@onready var center: ShapeCast2D = $center
@onready var walls: Array[ShapeCast2D] = [$left, $right, center]
@onready var _half: Vector2 = center.shape.size / 2

func set_direction(direction: Vector2) -> void:
	var i: int = offset.size()
	
	position = direction * (distance + _half)
	var norm: Vector2 = position.orthogonal().normalized()
	
	while i > 0:
		i -= 1
		walls[i].position = norm * offset[i]
