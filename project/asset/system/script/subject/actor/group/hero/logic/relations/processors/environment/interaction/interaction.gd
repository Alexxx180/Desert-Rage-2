extends Node

@onready var act: Node = $act
@onready var press: Node = $press
@onready var transition: Node = $transition
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, interaction: Node) -> void:
	var tags: TileMapLayer = hero.get_node("../../tags")
	var activators: Node = tags.activators
	#var execute: TileMapLayer = hero.get_node("../../execute")
	act.controls(hero, interaction.act, activators.trigger)
	press.controls(hero, interaction.press, activators.button)
	transition.controls(hero, interaction.transition, tags)
	pull.controls(hero, interaction.pull)
