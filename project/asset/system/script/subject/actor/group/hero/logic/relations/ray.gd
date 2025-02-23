extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var floors: Node = $floors

func controls(hero: CharacterBody2D, world: Node) -> void:
	var tags: TileMapLayer = hero.get_node("../../tags")
	skills.controls(hero, world.skills, tags)
	ability.controls(hero, world.ability, tags.activators)
	floors.controls(hero, world.floors)
