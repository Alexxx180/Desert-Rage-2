extends Node

var _leaf

func search_for_theme() -> void:
	pass

func add_theme(group: Array, tracks: Array[String], i: int) -> void:
	var leaf: Control = group[i]
	var parent: Control = leaf.get_parent()
	leaf.add_sibling(_leaf.instantiate())
	parent.remove_child(leaf)
	group.remove_at(i)
	leaf.queue_free()
