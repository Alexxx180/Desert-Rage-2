extends RefCounted

class_name SoundtrackTreeQuery

const PATH: String = "res://asset/resource/media/ost/manifest.json"

var _user: Dictionary
var _copy: Dictionary
var _ui: Control
var pad: String = "left"

func _decide(key: String) -> Variant:
	return _user[key] if _user.has(key) else _copy[key]

func get_context() -> Dictionary: return _copy

func init_manifest() -> bool:
	var text: String = FileAccess.open(PATH, FileAccess.READ).get_as_text()
	var processor: JSON = JSON.new()
	var valid: bool = processor.parse(text) == OK
	if valid:
		_copy = processor.data
		_user = _copy
	return valid

func set_ui(ui: Control) -> void:
	_ui = ui

func set_data(user: Dictionary, original: Dictionary) -> void:
	_user = user
	_copy = original

func add_child(element: Control, recurse: bool = false) -> void:
	_ui.add_child(element)
	if recurse:
		_ui = element

func copy(branch: String = pad) -> SoundtrackTreeQuery:
	var query = SoundtrackTreeQuery.new()
	query.set_data(_user, _copy)
	query.set_ui(_ui)
	query.pad = branch
	return query

func select(branch: String) -> SoundtrackTreeQuery:
	match branch:
		"type": _ui = _ui.content.head.content.body
		"name": _ui = _ui.content.body
	_user = _decide(branch)
	_copy = _copy[branch]
	return self
