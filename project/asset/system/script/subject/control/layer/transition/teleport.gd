extends Node

var teleporters: Dictionary = {} # int, Node2D

func transit(hero: CharacterBody2D, logic: Dictionary) -> void:
	assert(logic.name == "none", "Teleporter is not connected!")
	var no: int = Tiling.logic(logic.cell)
	hero.teleport(teleporters[no])
