extends Node

var play: Node

@onready var resolve: Node = $resolve

func set_play_status(metadata: Dictionary) -> void:
	var status: String = resolve.a_status(metadata) ; print("PLAYING!")
	var track: String = resolve.an_ost(metadata.track)
	play.set_playback(resolve.get_status(track, status))

func form_ost(entry: Dictionary, ui: Control, theme: String, get_key: String) -> Dictionary:
	var key: Variant = get("_" + get_key).call(ui)
	var track: Variant = get("_from_" + theme).call(entry, key)
	return resolve.form(ui.caption, key, track)

func form_ambient(entry: Dictionary, ui: Control, status: String) -> Dictionary:
	var caption: String = ui.content[status].caption
	var track: Variant = resolve.from_set(entry, ui.i)[status]
	return resolve.form(caption, status, track)

func _theme(op: String, entry: Dictionary, ui: Control, theme: String, get_key: String) -> void:
	resolve.an_entry(op, entry, ui)
	set_play_status(form_ost(entry, ui, theme, get_key))

func _ambient(entry: Dictionary, ui: Control, status: String) -> void:
	resolve.set_rampage(play.board, status)
	resolve.select_entry(entry, ui)
	set_play_status(form_ambient(entry, ui, status))

func as_theme(entry: Dictionary, ui: Control) -> void: _theme("select", entry, ui, "set", "no")
func as_named(entry: Dictionary, ui: Control) -> void: _theme("play", entry, ui, "theme", "name")
func as_blend(entry: Dictionary, ui: Control) -> void: _theme("play", entry, ui, "set", "name")
func as_ambient(entry: Dictionary, status: String, ui: Control) -> void: _ambient(entry, ui, status)
