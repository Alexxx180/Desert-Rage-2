extends Node # @onready var feet: Node = $feet

var _hero: CharacterBody2D
var act: Node:
	get: return _hero.to.topdown.move.act
var collision_on: bool = true

func controls(hero: CharacterBody2D, jump: Node) -> void: # overview controls...
	_hero = hero
	var levels: Node2D = hero.logic.see.levels
	var ledges: Area2D = levels.platform.ledges
	# var type: Node = hero.to.topdown.move.act.teleport

	jump.ledges.space.setup(hero)
	jump.ledges.place.floors = jump.feet.floors
	jump.surface = levels.platform.surface

	ledges.body_entered.connect(jump.ledges.append)
	ledges.body_exited.connect(jump.ledges.remove)
	controls_feet(jump.feet, levels)

func _set_movement(control: bool) -> void: # if not control:
	collision_on = control
	_hero.to.layers.context(control).collide_main() # Processors.turn(_movement, control) # TODO stop control # Processors.turn(_platforming, !control)
	_hero.to.skills.pull.reset_monitoring(control) # false

func connect_border(hero: CharacterBody2D, feet: Node) -> void:
	if hero.group.lay != null:
		feet.floors.border = hero.group.lay.border

func controls_feet(feet: Node, _levels: Node) -> void:
	feet.dash.connect(act.teleport.dash)
	feet.teleport.connect(act.teleport.teleport)
	feet.set_movement.connect(_set_movement)
	feet.set_deploy(_hero.to.platform.surface.deploy)
	# TODO FIXME connect floor border
	# connect_border(hero, feet)
	feet.floors.hero = _hero

func connect_platformer(env: Node, hero: CharacterBody2D) -> void:
	env.chains = hero.to.platformer.tools.chains

func controls_pillar(hero: CharacterBody2D, pillar: Node) -> void:
	var levels: Node2D = hero.logic.see.levels
	var env: Node = pillar.env
	env.view = hero.view
	env.whip = levels.tools.chains.whip
	env.layers = hero.to.layers
	env.pillars = levels.tools.pillar
	# TODO FIXME platformer connect
	# connect_platformer(env, hero)
	env.floors = hero.to.topdown.levels.jump.feet.floors
	# env.floors.border = hero.group.get_node("../tags").lay.border # TODO FIXME border floor
	env.teleport = hero.to.topdown.move.act.teleport
	env.levels = levels

	pillar.ledges.env = env
	pillar.ledges.ledge.node = levels.tools.pillar
