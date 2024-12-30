extends Node

@onready var transition: Node = $transition
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, interaction: Node) -> void:
	transition.controls(hero, interaction.transition)
	pull.controls(hero, interaction.pull)
