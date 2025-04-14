extends Node

var enabled: bool = false

func on_toggle(toggled: bool) -> void:
	enabled = toggled
	print(name + " enabled: ", enabled)

func from_theme(entry: Dictionary, ui: Control) -> void:
	if enabled and entry.theme.size() > 1:
		var i: int = ui.i
		var branch: Control = ui.get_parent()
		entry.ui.remove_at(i)
		entry.theme.remove_at(i)
		var j: int = entry.theme.size()
		while j > i:
			j -= 1
			entry.ui[j].i = j
		branch.remove_child(ui)
		
