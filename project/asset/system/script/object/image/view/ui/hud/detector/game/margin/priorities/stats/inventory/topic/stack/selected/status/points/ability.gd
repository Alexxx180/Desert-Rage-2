extends StatusPoints

func key() -> String: return "a"

func set_inventory(hero: Node2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.reload_resource)
