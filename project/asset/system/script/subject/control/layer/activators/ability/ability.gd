extends Node

@onready var freeze = $freeze
@onready var puddle = $puddle

var execute: TileDecorator:
	set(value):
		freeze.execute = value
		puddle.execute = value
