extends Node

@onready var ability: Node = $ability
@onready var activator: Node = $activator

func setup_ability(execute: TileMapLayer) -> void:
	ability.execute = TileDecorator.new(execute)
	var charge: Node = ability.puddle.spark.chains.charge
	charge.activate.connect(activator.trigger.map_activate)

func setup(location: Node, execute: TileMapLayer) -> void:
	setup_ability(execute)
	activator.set_location(location)
