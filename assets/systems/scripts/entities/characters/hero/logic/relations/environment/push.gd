extends Node

func set_control(impulse: Node, stats: Node) -> void:
	stats.impulse.connect(impulse.push.set_impulse)
	stats.impulse.emit(stats.push.value)
