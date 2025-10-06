extends Node

@onready var chains: Node = $chains
@onready var jump: Node = $jump

func process_physics(delta: float) -> void:
	chains.process_physics(delta)
	jump.process_physics(delta)
