extends Node

enum { JAR = 0, WATER = 6 }

var items: Node

func fill_the_jar() -> void:
	var slot: int = items.find_same_item(JAR)
	if items.have(slot): items.replace_item(slot, WATER) # logic.use_the_jar(jar, water, 1)

func distract(slot: Dictionary, item: Variant) -> void:
	pass # effect.special.distract()

func store_water(slot: Dictionary, item: Variant) -> void:
	fill_the_jar()
