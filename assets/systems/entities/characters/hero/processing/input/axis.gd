extends Node

@export var straight: String
@export var opposite: String

var axis: float:
	get:
		return Input.get_axis(straight, opposite)
