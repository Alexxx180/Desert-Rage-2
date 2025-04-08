extends Node

@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: Control) -> void:
	setup.set_soundtrack(options, detector)
