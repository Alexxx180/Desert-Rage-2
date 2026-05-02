extends GPUParticles2D

class_name FireParticle

func _ready() -> void:
	one_shot = true

func dissapear() -> void:
	call_deferred("queue_free")
