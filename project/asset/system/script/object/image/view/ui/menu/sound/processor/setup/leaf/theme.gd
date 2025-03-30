extends Node

var _theme = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var _fight = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

func _set_metadata(leaf: Button, track: String) -> void:
	leaf.path = track.replace("\\", "/")
	leaf.caption = leaf.path.substr(track.rfind("/")).substr(track.rfind("."))

func _combat_meta(leafs: HBoxContainer, tracks: Dictionary, meta: String) -> void:
	_set_metadata(leafs.content[meta], tracks[meta])

func set_common(list: VBoxContainer, track: String) -> void:
	var leaf: Control = _theme.instantiate()
	list.add_child(leaf)
	_set_metadata(leaf, track)

func set_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	var combat: Control = _fight.instantiate()
	list.add_child(combat)
	for status in ["ambient", "heating", "rampage"]:
		_combat_meta(combat, tracks, status)
