extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var unique: Node = $unique
@onready var fight: Node = $fight

func controls(hero: CharacterBody2D, world: Node) -> void:
	hero.to.layers.hero = hero # if hero.group.lay == null: return
	skills.controls(hero, world.skills)
	# ability.controls(hero, world.ability, root.group.work.lockers.ability)
	# unique.controls(hero) # TODO FIXME fight unique
	# fight.controls(hero, world.fight)
