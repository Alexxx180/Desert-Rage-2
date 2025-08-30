extends Node

signal transport()

var health: Node
var path: Node

func start() -> void:
	path.freeze_motion()

func end() -> void:
	health.aura.diffusion() # comment for 18+ scene

func effect() -> void:
	health.points.revive()
	transport.emit()
	path.ignite_motion()
	# entity.queue_free()
