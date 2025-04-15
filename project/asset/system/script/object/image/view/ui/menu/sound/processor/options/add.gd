extends Node

var theme: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var fight: Resource = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

var enabled: bool = false

func on_toggle(toggled: bool) -> void:
	enabled = toggled
	print(name + " enabled: ", enabled)

func _add_leaf(entry: Dictionary, kind: Resource, ui: Control) -> Control:
	var leaf: Control = kind.instantiate()
	ui.add_sibling(leaf)
	leaf.i = ui.i + 1
	var i: int = leaf.i
	entry.ui.set.insert(i, leaf)
	while i < entry.ui.size():
		i += 1
		entry.ui.set[i] = i
	return leaf

func to_theme(options: Node, entry: Dictionary, ui: Control) -> void:
	var metadata: Dictionary = {}
	if enabled and SoundtrackSystem.get_file(metadata):
		var leaf: Control = _add_leaf(entry, theme, ui)
		entry.theme.set.insert(leaf.i, metadata.track)
		options.set_leaf_theme(entry, leaf)

func to_ambient(options: Node, entry: Dictionary, ui: Control) -> void:
	if enabled:
		var leaf: Control = _add_leaf(entry, fight, ui)
		entry.theme.set.insert(leaf.i, { "ambient": "", "heating": "", "rampage": "" })
		options.set_ambient_theme(entry, leaf)
