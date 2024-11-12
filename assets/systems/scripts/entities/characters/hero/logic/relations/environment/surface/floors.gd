extends Node

func set_control(floors: FloorsQueue, overview: Node) -> void:
	floors.update.connect(overview.height.set_floor)
