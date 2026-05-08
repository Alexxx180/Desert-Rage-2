class_name FireParticle extends GPUParticles2D

func _ready() -> void:
	one_shot = true

func dissapear() -> void:
	call_deferred("queue_free")
