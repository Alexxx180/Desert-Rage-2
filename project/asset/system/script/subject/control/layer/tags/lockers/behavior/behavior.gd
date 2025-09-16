extends Node

@onready var ability: Node = $ability
@onready var activator: Node = $activator

func setup_ability(execute: TileMapLayer, border: TileMapLayer) -> void:
	ability.execute = TileDecorator.new(execute)
	ability.border = TileDecorator.new(border)
	var charge: Node = ability.puddle.spark.chains.charge
	charge.activate.connect(activator.trigger.map_activate)

func setup(location: Node, execute: TileMapLayer) -> void:
	setup_ability(execute, location.search.execute)
	activator.set_location(location)
