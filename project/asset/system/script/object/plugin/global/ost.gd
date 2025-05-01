extends Node

signal update()

var _json: Dictionary = {
	"COPY": "res://asset/resource/media/ost/%s.json",
	"USER": "user://%s.json"
}

var save: bool = false
var _copy: Dictionary = { "music": Defaults.DICT }
var _user: Dictionary
var user: Dictionary:
	get: return _user
var copy: Dictionary:
	get: return _copy

var _valid: Dictionary = {
	"music": { "copy": false, "user": false }
}

func is_valid(type: String) -> bool:
	return _valid[type].copy and _valid[type].user

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
	_init_vault("music")

func reset() -> void:
	_init_vault("music", true)

func reimport() -> void:
	_init_vault("music")

func _set_vault(from: String, to: String, force: bool = false) -> void:
	Vault.copy(from, to, force)
	_copy.music = Vault.get_json(from, func(s): _valid.music.copy = s)
	_user.music = Vault.get_json(to, func(s): _valid.music.user = s)

func _init_vault(type: String, force: bool = false) -> void:
	_set_vault(_json.COPY % type, _json.USER % type, force)

func _save_manifest(type: String) -> void:
	Vault.set_json(_json.USER % type, _user[type])

func save_changes() -> void:
	if save:
		update_ost()
		_save_manifest("music")
	save = false

func _exit_tree() -> void:
	save_changes()
