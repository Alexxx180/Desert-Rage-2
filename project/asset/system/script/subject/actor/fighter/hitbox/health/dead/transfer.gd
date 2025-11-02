extends Node

signal transport()

var damage: Area2D
var health: Node
var path: Node

func start() -> void:
	path.freeze_motion()
	damage.monitoring = false

func end() -> void:
	health.aura.diffusion() # comment for 18+ scene

func effect() -> void:
	health.points.revive()
	transport.emit()
	# entity.queue_free()
