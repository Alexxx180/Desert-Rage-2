extends Node

@onready var act: Node = $act
@onready var press: Node = $press
@onready var transition: Node = $transition
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, skills: Node, tags: TileMapLayer) -> void:
	var activator: Node = tags.lockers.behavior.activator
	act.controls(hero, skills.act, activator.trigger)
	press.controls(hero, skills.press, activator.button)
	transition.controls(hero, skills.transition, tags)
	pull.controls(hero, skills.pull)
