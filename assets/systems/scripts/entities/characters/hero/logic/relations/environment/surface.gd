extends Node

func set_control(processor: Node, jump: Node) -> void:
	processor.on_floors.connect(jump.placement)
