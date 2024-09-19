extends StaticBody2D

@onready var push: Node2D = $push
@onready var placement: CollisionShape2D = $placement

func set_control_entity(box: Node2D) -> void:
	push.set_control_entity(box)
