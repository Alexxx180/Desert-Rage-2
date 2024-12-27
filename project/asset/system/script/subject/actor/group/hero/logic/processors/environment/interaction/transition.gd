extends Node

var logic: TileMapLayer
var hero: CharacterBody2D

func encounter(execute: TileMapLayer) -> void:
	logic.transition.transit(execute, hero)
