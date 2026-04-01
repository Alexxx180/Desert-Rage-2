extends Node

var _act: Node
var _hero: CharacterBody2D
var collision_on: bool = true

func _set_movement(control: bool) -> void: # if not control:
	collision_on = control
	_hero.to.layers.context(control).collide_main() # Processors.turn(_movement, control) # TODO stop control # Processors.turn(_platforming, !control)
	_hero.to.skills.pull.reset_monitoring(control) # false

func connect_border(hero: CharacterBody2D, feet: Node) -> void:
	if hero.group.lay != null:
		feet.floors.border = hero.group.lay.border

func controls(hero: CharacterBody2D, feet: Node, levels: Node) -> void:
	_hero = hero
	_act = hero.to.topdown.move.act

	feet.dash.connect(_act.teleport.dash)
	feet.teleport.connect(_act.teleport.teleport)
	feet.set_movement.connect(_set_movement)
	feet.set_deploy(hero.to.platform.surface.deploy)
	# TODO FIXME connect floor border
	# connect_border(hero, feet)
	feet.floors.hero = hero
