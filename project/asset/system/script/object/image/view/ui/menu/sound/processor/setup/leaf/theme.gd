extends Node

var _theme = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var _fight = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

func set_common(list: VBoxContainer, track: String) -> void:
	var leaf: Control = _theme.instantiate()
	list.add_child(leaf)
	leaf.set_metadata(track)

func set_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	var combat: Control = _fight.instantiate()
	list.add_child(combat)
	for status in ["ambient", "heating", "rampage"]:
		combat.content[status].set_metadata(tracks[status])
