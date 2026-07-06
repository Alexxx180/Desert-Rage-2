extends GPUParticles2D

class_name SandParticle

@onready var timer: Timer = $timer

func _ready() -> void:
	emitting = false

func appear() -> void:
	emitting = true
	timer.start()

func dissapear() -> void:
	emitting = false
	# call_deferred("queue_free")
