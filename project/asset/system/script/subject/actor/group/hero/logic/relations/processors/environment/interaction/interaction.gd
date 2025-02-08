extends Node

@onready var act: Node = $act
@onready var press: Node = $press
@onready var transition: Node = $transition
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, interaction: Node) -> void:
	var tags: TileMapLayer = hero.get_node("../../tags")
	act.controls(hero, interaction.act, tags)
	press.controls(hero, interaction.press, tags)
	transition.controls(hero, interaction.transition, tags)
	pull.controls(hero, interaction.pull)
