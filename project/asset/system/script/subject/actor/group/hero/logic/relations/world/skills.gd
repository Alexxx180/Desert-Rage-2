extends Node

@onready var act: Node = $act
@onready var press: Node = $press
@onready var transition: Node = $transition
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, skills: Node, tags: TileMapLayer) -> void:
	var activators: Node = tags.activators
	act.controls(hero, skills.act, activators.trigger)
	press.controls(hero, skills.press, activators.button)
	transition.controls(hero, skills.transition, tags)
	pull.controls(hero, skills.pull)
