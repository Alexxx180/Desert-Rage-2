extends Node

signal update()

const MANIFEST: String = "res://asset/resource/media/ost/%s.json"
const USER: String = "user://%.json"

var _copy: Dictionary = { "music": Defaults.DICT }
var _user: Dictionary
var user: Dictionary:
	get: return _user
var copy: Dictionary:
	get: return _copy

var _valid: Dictionary = { "music": false, "sound": false }

func is_valid(type: String) -> bool: return _valid[type]
func update_ost() -> void: update.emit()

func get_file(metadata: Dictionary) -> bool:
	metadata.track = "F:/media/ost/music/songs/group/english/p-t/t/Three_Days_Grace_-_I_Hate_Everything_About_You_47958582.mp3"
	return true

func get_value(ui: Dictionary, keys: Array) -> Dictionary:
	var context: Dictionary = { "ui": ui, "ost": user["music"] }
	for key in keys:
		context.ost = context.ost[key]
		context.ui = context.ui[key]
	return context

func _ready() -> void:
	_set_vault("music")

func reset() -> void:
	_user.music = _copy.music

func _set_vault(theme: String) -> void:
	var dir: DirAccess = DirAccess.open("user://")
	var to: String = theme + ".json"
	_copy.music = _init_manifest(theme)
	if not dir.file_exists(to):
		var from: String = MANIFEST % theme
		dir.copy(from, to)
	_user.music = _init_manifest(theme)

func _init_manifest(type: String) -> Dictionary:
	var path: String = MANIFEST % type
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	_valid[type] = processor.parse(text) == OK
	return processor.data if _valid[type] else Defaults.DICT

func _save_manifest(type: String) -> void:
	var path: String = USER % type
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var json: String = JSON.stringify(_user[type])
	file.story_string(json)

func _exit_tree() -> void:
	_save_manifest("music")
