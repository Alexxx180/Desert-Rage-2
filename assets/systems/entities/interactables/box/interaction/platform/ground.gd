extends Node

@export_range(0, 2) var height: int = 1

var ground: Node

var F: int:
	get: return ground.F + height
