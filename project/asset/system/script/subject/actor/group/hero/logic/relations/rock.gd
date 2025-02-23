extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var floors: Node = $floors

func controls(hero: CharacterBody2D, world: Node) -> void:
	var map: Node2D = hero.get_node("../..")
	var tags: TileMapLayer = map.get_node("tags")
	
	skills.controls(hero, world.skills, tags)
	ability.controls(hero, world.ability, map)
	floors.controls(hero, world.floors)
