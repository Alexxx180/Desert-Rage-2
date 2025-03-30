extends Node

var _theme = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf.tscn")
var _fight = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf.tscn")

func _set_metadata(leaf: Control, track: String) -> void:
	leaf.path = track.replace("\\", "/")
	leaf.name = leaf.path.substr(track.rfind("/"))

func _combat_meta(leaf: Control, tracks: Dictionary, meta: String) -> void:
	_set_metadata(leaf.combat[meta], tracks[meta])

func set_common(list: VBoxContainer, track: String) -> void:
	var leaf: Control = _theme.instantiate()
	_set_metadata(leaf.track, track)
	list.add_child(leaf)

func set_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	var combat: Control = _fight.instantiate()
	for status in ["ambient", "heating", "rampage"]:
		_combat_meta(combat, tracks, status)
	list.add_child(combat)
