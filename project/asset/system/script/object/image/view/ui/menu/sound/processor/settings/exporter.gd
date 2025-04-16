extends Node

@onready var save: SavePresetDialog = $save

func _store_file(path: String) -> void:
	pass # TODO ost zip export operation

func _export(path: String) -> void:
	# soundtrack dictionary to path
	_store_file(path)

func exporting() -> void:
	save.show_dialog(_export)
