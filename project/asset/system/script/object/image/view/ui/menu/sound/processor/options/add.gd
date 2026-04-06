extends Node

var context: OpenThemeDialog

func _add_leaf(entry: Dictionary, kind: Resource, ui: Control) -> Control:
	SoundtrackSystem.save = true
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

func _get_ambient() -> Dictionary:
	var track: String = context.result_file
	return { "ambient": track, "heating": track, "rampage": track }

func to_theme(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, Defaults.pre.ost.theme, ui)
	entry.theme.set.insert(leaf.i, context.result_file)
	options.set_leaf_theme(entry, leaf)

func to_ambient(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, Defaults.pre.ost.fight, ui)
	entry.theme.set.insert(leaf.i, _get_ambient())
	options.set_ambient_theme(entry, leaf)
