extends Node

func set_control(box: StaticBody2D, push: Node) -> void:
	push.forward.timeout.connect(box.push)
