extends StatusPoints

const _jars: Array[int] = [6, 8, 10]

func get_jars() -> Array[int]: return _jars

func set_inventory(hero: Node2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.reload_resource)
