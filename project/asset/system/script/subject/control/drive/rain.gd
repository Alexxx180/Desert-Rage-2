extends Node2D

class_name RainParticle

func _ready() -> void:
	$droplets.one_shot = true

func set_direction(direction: Vector2) -> void:
	position += direction * 32

func dissapear() -> void:
	call_deferred("queue_free")
