extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var unique: Node = $unique
@onready var fight: Node = $fight

func controls(hero: CharacterBody2D, world: Node) -> void:
	hero.to.layers.hero = hero # if hero.group.lay == null: return
	
	var tags: TileDecorator = hero.group.lay.tags
	if tags != null:
		skills.controls(hero, world.skills, tags.layer)
		ability.controls(hero, world.ability, tags.layer.lockers.ability)
		unique.controls(hero)
		fight.controls(hero, world.fight)
