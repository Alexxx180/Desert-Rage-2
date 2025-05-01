extends Button

@onready var listener: Node = $listener

func start_listen_input() -> void:
	Processors.turn(listener, true)
