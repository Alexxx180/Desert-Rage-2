extends Area2D

@onready var geometry: CollisionShape2D = $geometry

@onready var shape: RectangleShape2D = geometry.shape
@onready var size: Vector2 = shape.size

const DISTANCE: Vector2i = Vector2i(15, 9) # 15, 9

func set_direction(direction: Vector2i) -> void:
	pass
	"""
	position = direction * DISTANCE
	
	shape.size.x = size.x
	shape.size.y = size.y
	
	direction.x = abs(direction.x)
	direction.y = abs(direction.y)
	
	if direction.x != direction.y:
		shape.size.x += size.x * direction.y * 3
		shape.size.y += size.y * direction.x * 2
"""
