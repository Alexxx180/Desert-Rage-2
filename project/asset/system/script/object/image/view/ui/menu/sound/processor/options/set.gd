extends Node

var _leaf

func add_leaf(branch: Control) -> void:
	var next: Control = _leaf.instantiate()
	branch.add_child(next)

func set_theme(group: Array, tracks: Array[String], i: int) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		add_leaf(group[i].get_parent())
		tracks.insert(i, metadata.track)
