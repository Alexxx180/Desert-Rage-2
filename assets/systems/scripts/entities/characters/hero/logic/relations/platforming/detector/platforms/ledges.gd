extends Node

func set_control(ledges: Area2D, processor: Node) -> void:
	ledges.area_entered.connect(processor.append)
	ledges.area_exited.connect(processor.remove)
