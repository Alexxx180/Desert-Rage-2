extends Node

var hero: CharacterBody2D
var hud: CanvasLayer

var items: Node

func drag_item() -> void:
	pass

func use_item(slot: int, item: Dictionary) -> void:
	match item.id:
		HeroInventory.WATER:
			items.put_item(slot, item)
