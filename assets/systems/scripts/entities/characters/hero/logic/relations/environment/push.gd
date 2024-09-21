extends Node

func set_control(push: Node, stats: Node) -> void:
	stats.impulse.connect(push.set_impulse)
