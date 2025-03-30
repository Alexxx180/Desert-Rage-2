extends Node

@onready var theme: Node = $theme

func _set_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	for track in tracks:
		theme.set_combat(list, track)

func _set_themes(list: VBoxContainer, tracks: Dictionary) -> void:
	for track in tracks:
		theme.set_common(list, track)

func determine_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	if tracks.set[0] is Dictionary:
		_set_combat(list, tracks.set)
	else:
		_set_themes(list, tracks.set)
