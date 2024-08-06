extends Node

@onready var _platforming: Node = $processing/platforming
@onready var _movement: Node = $processing/movement

var platforming: Node.ProcessMode:
	set(mode):
		_platforming.process_mode = mode

var movement: Node.ProcessMode:
	set(mode):
		_movement.process_mode = mode
