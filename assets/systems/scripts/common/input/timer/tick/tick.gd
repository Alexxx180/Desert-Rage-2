extends Node

@onready var processor: Node = $processor

func _switch(active: bool) -> void:
	Processors.turn(processor, active)

func stop() -> void:
	_switch(false)

func start() -> void:
	_switch(true)
