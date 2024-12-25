extends Node2D

@onready var stand: Sprite2D = $stand
@onready var heroes: Dictionary = { "ray": $ray, "rock": $rock }

func enable_sync(seat: Node, hero: CharacterBody2D) -> void:
	var view: Node2D = heroes[hero.name]
	view.visible = true
	view.enable_sync(seat, hero)

func disable_sync(seat: Node, hero: CharacterBody2D) -> void:
	var view: Node2D = heroes[hero.name]
	view.visible = false
	view.disable_sync(seat, hero)
