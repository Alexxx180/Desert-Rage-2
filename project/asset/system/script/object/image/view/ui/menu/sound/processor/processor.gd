extends Node

@onready var settings: Node = $settings
@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	settings.setup = setup
	settings.set_info(detector.settings.info)
	setup.set_soundtrack(options, detector)
