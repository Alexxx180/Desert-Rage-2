extends Node

func set_control(box: StaticBody2D, push: Node) -> void:
	print("CONNECT")
	push.forward.timeout.connect(box.push)
