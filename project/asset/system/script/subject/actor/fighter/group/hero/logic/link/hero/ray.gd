extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var unique: Node = $unique
@onready var fight: Node = $fight

func controls(hero: CharacterBody2D, world: Node) -> void:
	hero.to.layers.hero = hero
	#if hero.group.lay == null: return
	
	var tags: TileMapLayer = hero.group.get_node("../tags")
	#if tags == null: return
	
	skills.controls(hero, world.skills, tags)
	ability.controls(hero, world.ability, tags.lockers.ability)
	unique.controls(hero)
	fight.controls(hero, world.fight)
