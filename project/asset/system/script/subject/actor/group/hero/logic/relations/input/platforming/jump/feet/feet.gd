extends Node

enum { WORLD = 1, BORDERS = 2 }

@onready var floors: Node = $floors
@onready var balance: Node = $balance

func controls(hero: CharacterBody2D, feet: Node, platforming: Node) -> void:
	floors.controls(hero, feet.floors)
	balance.controls(hero, feet.balance)

	feet.deployment = platforming.platforms.surface.deployment
