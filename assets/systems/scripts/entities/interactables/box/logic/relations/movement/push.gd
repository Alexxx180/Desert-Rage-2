extends Node

func set_control(box: CharacterBody2D, push: Node) -> void:
	#push.timeout.connect(box.push)
	push.forward.timeout.connect(box.push)
	push.weight = box.weight
