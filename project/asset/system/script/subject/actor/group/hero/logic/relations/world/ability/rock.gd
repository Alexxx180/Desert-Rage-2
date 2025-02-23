extends Node

@onready var rain: Node = $rain

func controls(hero: CharacterBody2D, ability: Node, map: Node2D) -> void:
	var border: TileMapLayer = map.get_node("border")
	var execute: TileMapLayer = map.get_node("execute")
	
	rain.controls(hero, ability.rain, border)#, execute) #...
