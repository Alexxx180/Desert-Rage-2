extends Area2D

signal contact()#pos: Vector2)

@onready var ray: RayCast2D = $ray
#@onready var stand: ShapeCast2D = $stand
@onready var target: Vector2 = ray.target_position

func _set_contact(_body: Node2D) -> void:
	contact.emit()#allowed)
	#if ray.is_colliding():
	#	contact.emit(Vector2.ZERO)
	#else:
	#	contact.emit(ray.target_position)

func set_direction(direction: Vector2):
	if direction != Vector2.ZERO:
		ray.target_position = target * direction
