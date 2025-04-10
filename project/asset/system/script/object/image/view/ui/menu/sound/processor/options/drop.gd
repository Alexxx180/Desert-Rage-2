extends Node

var enabled: bool = false

func from_theme(entry: Dictionary) -> void:
	if enabled and entry.ost.size() > 1:
		var i: int = entry.i
		var leaf: Control = entry.ui[i]
		var branch: Control = leaf.get_parent()
		branch.remove_child(leaf)
		entry.ui.remove_at(i)
		var j: int = entry.ost.size()
		while j > i:
			j -= 1
			entry.ui[j].i = j

