extends Node

var theme: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var fight: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

var enabled: bool = false

func _add_leaf(entry: Dictionary, kind: Resource) -> void:
	var i: int = entry.i
	var leaf: Control = kind.instatiate()
	entry.ui[i].add_sibling(leaf)

func to_theme(entry: Dictionary) -> void:
	if not enabled: return
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		_add_leaf(entry, theme)
		entry.ost.insert(entry.i, metadata.track)

func to_ambient(entry: Dictionary) -> void:
	if not enabled: return
	_add_leaf(entry, fight)
	entry.ost.insert(entry.i, { "ambient": "", "heating": "", "rampage": "" })

