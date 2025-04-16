extends Node

class_name OSTLeaf

var ost: Dictionary

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		ui.set[i].i = i
		ui.set[i].set_options(options, context)
