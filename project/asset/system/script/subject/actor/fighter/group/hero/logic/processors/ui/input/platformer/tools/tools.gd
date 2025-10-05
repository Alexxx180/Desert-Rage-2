extends Node

@onready var chains: Node = $chains
@onready var spring: Node = $spring

func process_physics(delta: float) -> void:
	chains.process_physics(delta)
	spring.process_physics(delta)
