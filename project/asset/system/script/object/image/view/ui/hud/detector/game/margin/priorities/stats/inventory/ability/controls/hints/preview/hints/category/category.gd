extends VBoxContainer

class_name HintsCategory

func get_acts() -> Array[String]:
	var acts: Array[String] = []
	for i in get_children(): acts.append(i.name)
	return acts

func get_category() -> Dictionary:
	var category: Dictionary = {}
	for act in get_acts():
		category[act] = get_node(act)
	return category
