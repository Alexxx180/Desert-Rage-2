extends VBoxContainer

func get_category() -> Dictionary:
	var category: Dictionary = {}
	for act in ["move", "jump", "land", "push"]:
		category[act] = get_node(act)
	return category
