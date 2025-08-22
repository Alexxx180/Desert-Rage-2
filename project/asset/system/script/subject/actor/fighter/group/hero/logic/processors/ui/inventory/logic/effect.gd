extends Node

var hero: CharacterBody2D
var logic: Node

func drag_item() -> void:
	pass

func use_item(slot: int, item: Dictionary) -> void:
	match item.id:
		HeroInventory.WATER:
			var water: Dictionary = HeroInventory.get_items_bank()[item.id]
			var jar: int = logic.items.find_item_or_slot(logic.storage, HeroInventory.JAR)
			logic.use_the_jar(slot, jar, HeroInventory.JAR)
			hero.logic.processors.stats.health.refill(water.power)
			hero.logic.processors.stats.aura.refill(water.power)
