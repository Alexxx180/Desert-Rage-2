extends Node

func controls(box: CharacterBody2D, push: Node) -> void:
	#push.timeout.connect(box.push)
	#push.forward.timeout.connect(box.push)
	push.forwarding.connect(box.push)
	push.weight = box.weight
