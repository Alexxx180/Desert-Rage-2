extends Node

signal update()

const MANIFEST: String = "res://asset/resource/media/ost/%s.json"

@onready var _copy: Dictionary = { "music": init_manifest("music") }
@onready var _user: Dictionary = _copy

var user: Dictionary:
	get: return _user

var copy: Dictionary:
	get: return _copy

var _valid: Dictionary = { "music": false, "sound": false }

func is_valid(type: String) -> bool: return _valid[type]

func update_ost() -> void:
	update.emit()

func get_value(ui: Dictionary, keys: Array[String]) -> Dictionary:
	var context: Variant = user
	for key in keys:
		context = context[key]
		ui = ui[key]
	return { "ui": ui, "user": context }

func _ready() -> void:
	init_manifest("music")

func init_manifest(type: String) -> Dictionary:
	var path: String = MANIFEST % type
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	
	_valid[type] = processor.parse(text) == OK
	return processor.data if _valid[type] else Defaults.DICT
