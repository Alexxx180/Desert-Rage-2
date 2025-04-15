extends Node

var theme: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var fight: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

func _add_leaf(entry: Dictionary, kind: Resource, ui: Control) -> Control:
	var list: Array = entry.ui.set
	var leaf: Control = kind.instantiate()
	var i: int = ui.i + 1
	ui.add_sibling(leaf)
	list.insert(i, leaf)
	leaf.i = i
	i = list.size()
	while i > leaf.i:
		i -= 1
		list[i].i = i
	return leaf

func to_theme(options: Node, entry: Dictionary, ui: Control) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		var leaf: Control = _add_leaf(entry, theme, ui)
		entry.theme.set.insert(leaf.i, metadata.track)
		options.set_leaf_theme(entry, leaf)

func to_ambient(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, fight, ui)
	entry.theme.set.insert(leaf.i, { "ambient": "", "heating": "", "rampage": "" })
	options.set_ambient_theme(entry, leaf)
