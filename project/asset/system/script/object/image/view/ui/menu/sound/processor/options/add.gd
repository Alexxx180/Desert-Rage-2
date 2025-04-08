extends Node

var _leaf

func add_leaf(leaf: Control) -> void:
	var next: Control = _leaf.instantiate()
	leaf.add_sibling(next)

func add_theme(group: Array, tracks: Array[String], i: int) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		add_leaf(group[i])
		tracks.insert(i, metadata.track)
