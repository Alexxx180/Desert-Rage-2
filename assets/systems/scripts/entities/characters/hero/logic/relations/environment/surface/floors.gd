extends Node

func set_control(processor: FloorsQueue, overview: Node) -> void:
	processor.update.connect(overview.height.set_floor)
