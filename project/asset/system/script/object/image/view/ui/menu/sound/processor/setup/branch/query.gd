extends SoundtrackQuery

class_name TreeOST

const PATH: String = "res://asset/resource/media/ost/manifest.json"

var _copy: Variant
var ui_tree: Dictionary
var _ui: Control
var pad: String = "left"

func decide(key: String) -> Variant:
	return _user[key] if _user.has(key) else _copy[key]

func set_ui(ui: Control) -> void: _ui = ui

func set_ui_tree(ui: Dictionary) -> void: ui_tree = ui

func set_data(user: Dictionary, original: Dictionary) -> void:
	_user = user
	_copy = original

func add_child(element: Control, recurse: bool = false) -> void:
	_ui.add_child(element)
	if recurse:
		set_ui(element)

func copy(branch: String = pad) -> TreeOST:
	var query = TreeOST.new()
	query.set_data(_user, _copy)
	query.set_ui(_ui)
	query.set_ui_tree(ui_tree)
	query.pad = branch
	return query

func nest_full() -> TreeOST:
	return nest_head().nest_body()

func nest_head() -> TreeOST:
	_ui = _ui.content.head
	return self

func nest_body() -> TreeOST:
	_ui = _ui.content.body
	return self

func select(branch: String) -> TreeOST:
	_user = decide(branch)
	_copy = _copy[branch]
	ui_tree[branch] = {}
	ui_tree = ui_tree[branch]
	caption = branch
	return self
