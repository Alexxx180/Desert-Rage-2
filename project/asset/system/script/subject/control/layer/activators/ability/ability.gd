extends Node

@onready var freeze = $freeze
@onready var puddle = $puddle

var execute: TileDecorator:
	set(value):
		freeze.execute = value
		puddle.execute = value

func _ready() -> void:
	var drain: Node = puddle.spark.chains.drain
	freeze.fire_drain.connect(drain.evaporation)
