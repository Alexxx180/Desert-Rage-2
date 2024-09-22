extends Node

@onready var floors: Node = $floors

func set_control(processor: Node, jump: Node) -> void:
	processor.on_floors.connect(jump.placement)
	floors.set_control(processor.floors, jump.overview)
