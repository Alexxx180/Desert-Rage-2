extends Node

var logic: TileMapLayer
var hero: CharacterBody2D

func encounter(execute: TileMapLayer) -> void:
	var level: Dictionary = {
		"tags": logic, "execute": execute, "hero": hero
	}
	logic.transition.transit(level)
