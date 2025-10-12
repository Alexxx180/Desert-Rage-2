extends Node

@onready var freeze = $freeze
@onready var puddle = $puddle

func _ready() -> void:
	freeze.fire_drain.connect(puddle.spark.chains.drain.evaporation)

func setup(lay: Node, trigger: Node) -> void:
	puddle.lay = lay
	freeze.execute = lay.execute # execute: TileDecorator, border: TileDecorator
	puddle.spark.chains.charge.activate.connect(trigger.map_activate)
