extends Node

func from_theme(entry: Dictionary, ui: Control) -> void:
	SoundtrackSystem.save = true
	var themes: Array = entry.theme.set
	if themes.size() > 1:
		var i: int = ui.i
		var branch: Control = ui.get_parent()
		entry.ui.set.remove_at(i)
		themes.remove_at(i)
		var j: int = themes.size()
		while j > i:
			j -= 1
			entry.ui.set[j].i = j
		branch.remove_child(ui)
