extends RefCounted

class_name SoundtrackTreeQuery

const PATH: String = "res://asset/resource/media/ost/manifest.json"

var _user: Variant
var _copy: Variant
var _ui: Control
var pad: String = "left"
var caption: String = "initial"

var context: Variant:
	get: return _user

func decide(key: String) -> Variant:
	return _user[key] if _user.has(key) else _copy[key]

func set_ui(ui: Control) -> void:
	_ui = ui

func set_data(user: Dictionary, original: Dictionary) -> void:
	_user = user
	_copy = original

func add_child(element: Control, recurse: bool = false) -> void:
	_ui.add_child(element)
	if recurse:
		set_ui(element)

func copy(branch: String = pad) -> SoundtrackTreeQuery:
	var query = SoundtrackTreeQuery.new()
	query.set_data(_user, _copy)
	query.set_ui(_ui)
	query.pad = branch
	return query

func nest_head() -> SoundtrackTreeQuery:
	_ui = _ui.content.head
	return self

func nest_body() -> SoundtrackTreeQuery:
	_ui = _ui.content.body
	return self

func select(branch: String) -> SoundtrackTreeQuery:
	_user = decide(branch)
	_copy = _copy[branch]
	caption = branch
	return self
