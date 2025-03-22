extends Node

@onready var floors: Node = $floors
@onready var balance: Node = $balance

func controls(hero: CharacterBody2D, feet: Node, platforming: Node) -> void:
	feet.deployment = platforming.platforms.surface.deployment

	floors.controls(hero, feet.floors)
	balance.controls(hero, feet.balance)
