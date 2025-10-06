extends Node

@export var influence: int = 1

var is_near: bool:
	get: return pillar.is_near
var pillar: Node
var hero: CharacterBody2D:
	set(value):
		pillar = value.logic.work.input.topdown.levels.pillar

func take_effect() -> void:
	pillar.dash_on_whip()
