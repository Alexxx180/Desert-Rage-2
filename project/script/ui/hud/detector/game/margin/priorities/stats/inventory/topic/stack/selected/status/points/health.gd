extends StatusPoints

func set_inventory(hero: CharacterBody2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.quick_heal)
