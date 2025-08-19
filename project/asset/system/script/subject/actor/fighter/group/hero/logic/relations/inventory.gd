extends Node

func controls(hero: CharacterBody2D, inventory: Node) -> void:
	inventory.logic.inventory = hero.get_node("../..").hud.game.detector.menu.stats.inventory.topic.items.storage
	inventory.logic.update_inventory_storage()
