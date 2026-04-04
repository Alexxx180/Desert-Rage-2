extends Node

@onready var chains: Node = $chains
@onready var alone: Node = $alone

var _lay: Node
var lay: Node:
	set(value):
		_lay = value
		chains.lay = value
		alone.execute = value.execute
