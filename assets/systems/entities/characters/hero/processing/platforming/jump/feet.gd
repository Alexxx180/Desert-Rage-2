extends Node

var movement: Node
var decisions: Node

var _stable: bool = true
var stable: bool:
	get: return _stable
	set(is_floor):
		if (is_floor != _stable):
			movement.process_mode = decisions.decide(is_floor)
		_stable = is_floor

var unstable: bool:
	get: return not _stable

func set_control_entity(processing: Node):
	movement = processing.movement
	decisions = processing.decisions
