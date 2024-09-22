extends Node

func set_control(processor: Node, overview: Node) -> void:
	processor.on_floor_change.connect(overview.set_floor)
