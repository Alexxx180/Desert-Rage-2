extends Node

signal transit(hero: CharacterBody2D)

var hero: CharacterBody2D

func encounter(_execute: TileMapLayer) -> void:
	transit.emit(hero)
