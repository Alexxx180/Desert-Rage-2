extends Node

@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	setup.set_soundtrack(options, detector)
