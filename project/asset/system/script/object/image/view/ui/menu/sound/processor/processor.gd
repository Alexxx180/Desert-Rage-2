extends Node

@onready var settings: Node = $settings
@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	settings.set_info(detector.settings.info, setup)
	settings.set_tabs(detector.settings.tabs, options)
	setup.set_soundtrack(options, detector)
