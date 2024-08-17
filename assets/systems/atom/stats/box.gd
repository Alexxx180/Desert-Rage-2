extends Node

@onready var size: Node = $size

func set_control_entity(box: Node2D):
	size.set_control_entity(box)
