extends StatusPoints

const _jars: Array[int] = [1, 2, 6, 7, 9, 11, 12]

func get_jars() -> Array[int]: return _jars

func set_inventory(hero: CharacterBody2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.quick_heal)
