class_name PlatformingBox extends AnimatableBody2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_collide(velocity)
