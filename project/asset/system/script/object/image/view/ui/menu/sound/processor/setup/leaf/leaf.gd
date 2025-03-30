extends Node

@onready var theme: Node = $theme

func _set_combat(list: VBoxContainer, tracks: Array) -> void:
	for track in tracks:
		theme.set_combat(list, track)

func set_themes(list: VBoxContainer, tracks: Array) -> void:
	for track in tracks:
		theme.set_common(list, str(track))

func determine_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	if tracks.set.size() == 0: return
	
	if tracks.set[0] is Dictionary:
		_set_combat(list, tracks.set)
	else:
		set_themes(list, tracks.set)
