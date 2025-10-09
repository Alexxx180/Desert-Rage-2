extends Node

@onready var ability: Node = $ability
@onready var activator: Node = $activator

func setup_ability(execute: TileDecorator, border: TileDecorator) -> void:
	ability.execute = execute
	ability.border = border
	var charge: Node = ability.puddle.spark.chains.charge
	charge.activate.connect(activator.trigger.map_activate)

func setup(location: Node, execute: TileDecorator) -> void:
	setup_ability(execute, location.search.execute)
	activator.set_location(location)
