extends Node

@onready var button: Node = $button
@onready var trigger: Node = $trigger

func set_location(location: Node) -> void:
	button.location = location
	trigger.location = location
