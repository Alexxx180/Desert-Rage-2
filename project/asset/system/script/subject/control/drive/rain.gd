extends Node2D

class_name RainParticle

func _ready() -> void:
	$droplets.one_shot = true

func set_pos(pos: Vector2) -> RainParticle:
	position = pos
	return self

func set_direction(direction: Vector2) -> RainParticle:
	position += direction * 32
	return self

func dissapear() -> void:
	call_deferred("queue_free")
