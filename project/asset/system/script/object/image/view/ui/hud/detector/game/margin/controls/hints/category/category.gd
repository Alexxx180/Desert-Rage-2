extends VBoxContainer

class_name HintsCategory

func get_acts() -> Array[String]: return []

func get_category() -> Dictionary:
	var category: Dictionary = {}
	for act in get_acts():
		category[act] = get_node(act)
	return category
