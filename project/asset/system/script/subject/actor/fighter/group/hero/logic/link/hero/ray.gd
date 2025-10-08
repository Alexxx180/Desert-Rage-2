extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var unique: Node = $unique
@onready var fight: Node = $fight

func controls(hero: CharacterBody2D, world: Node) -> void:
	var tags: TileMapLayer = hero.get_node("../../tags")
	if tags != null:
		skills.controls(hero, world.skills, tags)
		ability.controls(hero, world.ability, tags.lockers.behavior)
		unique.controls(hero)
		fight.controls(hero, world.fight)
		hero.to.layers.hero = hero
