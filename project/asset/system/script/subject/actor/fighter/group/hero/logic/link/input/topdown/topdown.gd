extends Node

@onready var levels: Node = $levels
@onready var move: Node = $move
@onready var actions: Node = $actions

func controls(hero: CharacterBody2D, topdown: Node) -> void:
	actions.controls(hero, topdown)
	move.controls(hero, topdown.move)
	levels.controls(hero, topdown.levels)
