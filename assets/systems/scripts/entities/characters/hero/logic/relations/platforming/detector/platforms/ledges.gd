extends Node

func set_control(ledges: Area2D, processor: Node) -> void:
	ledges.body_entered.connect(processor.append)
	ledges.body_exited.connect(processor.remove)
