extends Node

func delete_theme(group: Array, tracks: Array[String], i: int) -> void:
	if tracks.size() == 1: return
	var leaf: Control = group[i]
	var parent: Control = leaf.get_parent()
	parent.remove_child(leaf)
	group.remove_at(i)
	leaf.queue_free()
