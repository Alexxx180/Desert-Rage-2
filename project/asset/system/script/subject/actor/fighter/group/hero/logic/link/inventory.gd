extends Node

func controls(hero: CharacterBody2D, inventory: Node) -> void:
	var chest: Area2D = hero.logic.see.world.skills.chest
	var level: Node2D = hero.get_node("../..")

	inventory.chest.hero = hero
	inventory.chest.logic = inventory.logic
	inventory.chest.chests = level.get_node("tags").chests
	
	inventory.logic.effect.hero = hero
	inventory.logic.effect.logic = inventory.logic

	chest.body_entered.connect(inventory.chest.enter_chest)
	chest.body_exited.connect(inventory.chest.exit_chest)
