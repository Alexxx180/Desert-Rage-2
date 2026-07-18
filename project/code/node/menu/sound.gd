extends Node

@onready var settings: Node = $settings
@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	settings.set_info(detector.settings.info, setup)
	settings.set_tabs(detector.settings.tabs, options)
	setup.set_soundtrack(options, detector)



extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

func set_info(info: VBoxContainer, setup: Node) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)

func set_tabs(tabs: VBoxContainer, options: Node) -> void:
	for o in [tabs.play, tabs.edit]: # TODO SET TABS
		o.pressed.connect(options.ost.switch_mode)


extends Node

@onready var operation: Node = $operation
@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

var ui: Dictionary

func op(key: String, entry: Dictionary, leaf: Control) -> void:
	operation.get("set_" + key + "_theme").call(self, entry, leaf)

func set_leaf_theme(e: Dictionary, l: Control) -> void: op("leaf", e, l)
func set_ambient_theme(e: Dictionary, l: Control) -> void: op("ambient", e, l)
func set_named_theme(e: Dictionary, l: Control) -> void: op("named", e, l)
func set_standalone(e: Dictionary, l: Control) -> void: op("standalone", e, l)
func set_blend_theme(e: Dictionary, l: Control) -> void: op("blend", e, l)
func set_theme_context(theme: OpenThemeDialog) -> void:
	add.context = theme
	search.theme = theme

func set_operations(menu: VBoxContainer) -> void:
	set_theme_context($theme)
	ost.setup_modes(self, menu)
	# play.set_menu_context(menu) # TODO FIXME SET MENU CONTEXT

func setup() -> void:
	ost.setup(self)
	play.set_ost(ost)




extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

var _ui: VBoxContainer
var _options: Node

func selection(query: TreeOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: TreeOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func setup() -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: TreeOST = TreeOST.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(_ui.dropdown)
		query.set_ui_tree(_options.ui)
		enumerate(query)
		_options.setup()

func _reload() -> void:
	for leaf in _ui.dropdown.get_children():
		_ui.dropdown.remove_child(leaf)
		leaf.queue_free()
	setup()

func reset() -> void:
	SoundtrackSystem.reset()
	_reload()

func reimport() -> void:
	SoundtrackSystem.reimport()
	_reload()

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	_options = options
	_ui = ui
	setup()
	if SoundtrackSystem.is_valid("music"):
		options.set_operations(_ui)


extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Alarm: ", query.caption)
	mark.actor.branch.set_alarm(query)
	return OK



extends BehaviorAction

func exist(mark: Tick) -> bool:
	var context: Variant = mark.blackboard.get_value("query").context
	return context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark) else FAILED




extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	return OK if query.context.set is Array else FAILED




extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set.size() > 0 and data.set[0] is Dictionary

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Combat: ", query.caption)
	mark.actor.branch.set_combat(query)
	return OK





extends BehaviorAction

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Themes: ", query.caption)
	mark.actor.branch.set_themes(query)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark)






extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary and data.mix is float

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Blend: ", query.caption)
	mark.actor.branch.set_blend(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Dictionary and data.values()[0] is String

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Named: ", query.caption)
	mark.actor.branch.set_named(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Trunk: ", query.caption)
	mark.actor.branch.set_trunks(mark.actor, query)
	return OK





extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Branch: ", query.caption)
	mark.actor.branch.set_branch(mark.actor, query)
	return OK





extends Node

@onready var leafs: Node = $leafs
@onready var ui: Node = $ui

func set_blend(query: TreeOST) -> void:
	leafs.set_blend(query, ui.blend)
	leafs.include(query, ui.named, leafs.set_titled, "set", {})

func set_trunks(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.trunk)
	setup.selection(query.copy("right").nest_full().select("type"))
	setup.selection(query.copy("left").nest_body().select("name"))

func set_branch(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.branch[query.pad])
	setup.enumerate(query.nest_body())

func set_alarm(query: TreeOST) -> void:
	leafs.set_alarm(query, ui.alarm)

func set_named(query: TreeOST) -> void:
	leafs.include(query, ui.named, leafs.set_titled, "", {})

func set_themes(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.theme, leafs.set_theme, "set", [])

func set_combat(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.fight, leafs.set_fight, "set", [])







extends Node

func append_child(query: TreeOST, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func set_child(query: TreeOST, child) -> Control:
	var caption: String = query.caption
	var branch: Control = append_child(query, child, true)
	branch.name = caption
	branch.caption = caption
	return branch

func set_theme(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(track)
	query.ui_tree.set.push_back(branch)

func set_fight(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	for status in track:
		var theme: String = track[status].track if track[status] is Dictionary else track[status]
		branch.content[status].set_metadata(theme)
	query.ui_tree.set.push_back(branch)

func set_titled(query, child, tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(tracks[track])
	branch.set_title(track)
	query.ui_tree.set[track] = branch

func set_mix(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	# query.set_ui(branch.content.themes.body)

func set_blend(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	query.set_ui(branch.content.themes.body)

func set_alarm(query: TreeOST, child) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(query.context)
	query.ui_tree.set = branch

func include(query, child, setter, list, init) -> void:
	var tracks: Variant = query.context if list == "" else query.decide(list)
	query.ui_tree.set = init
	for track in tracks:
		setter.call(query, child, tracks, track)




class_name SoundtrackUI extends RefCounted

var theme: PackedScene = preload("res://pre/ui/ost/leaf/leaf.tscn")
var fight: PackedScene = preload("res://pre/ui/ost/leaf/combat.tscn")
var alarm: PackedScene = preload("res://pre/ui/ost/leaf/alarm.tscn")
var named: PackedScene = preload("res://pre/ui/ost/leaf/named.tscn")

var trunk: PackedScene = preload("res://pre/ui/ost/trunk.tscn")
var branch: PackedScene = preload("res://pre/ui/ost/branch.tscn")
var blend: PackedScene = preload("res://pre/ui/ost/blend.tscn")
var mix: PackedScene = preload("res://pre/ui/ost/mix.tscn")





extends Node

signal no_manifest(file: String)
signal setup()

@onready var open: OpenPresetDialog = $open
@onready var _reader: ZIPReader = ZIPReader.new()

func _from_path(folder: DirAccess, file: String) -> String:
	return folder.get_current_dir().path_join(file)

func _set_one(folder: DirAccess, path: String) -> void:
	folder.make_dir_recursive(_from_path(folder, path).get_base_dir())
	var file: FileAccess = FileAccess.open(_from_path(folder, path), FileAccess.WRITE)
	file.store_buffer(_reader.read_file(path))

func _copy_files() -> void:
	var user: DirAccess = DirAccess.open("user://")
	for file in _reader.get_files():
		var path: String = file.replace("user://", "")
		if path.ends_with("/"):
			user.make_dir_recursive(path)
		else:
			_set_one(user, path)
	setup.emit()

func _extract(path: String) -> void:
	print("IMPORTING")
	var manifest: String = "music.json"
	
	_reader.open(path)
	if _reader.file_exists(manifest):
		_copy_files()
	else:
		print("NO MANIFEST!")
		no_manifest.emit(manifest)
	
	_reader.close()

func importing():
	open.show_dialog(_extract)



class_name ExportOST extends SoundtrackQuery

var result: Variant
var path: String

func set_user(user: Dictionary) -> void:
	_user = user

func set_path(file: String) -> void:
	path = file

func copy() -> ExportOST:
	var query = ExportOST.new()
	query.set_user(_user)#.duplicate())
	query.set_path(path)
	query.result = result# .duplicate()
	return query
	#return self

func get_path(track: String) -> String:
	return "user://" + path + track.substr(track.rfind("/") + 1) #  + "/"

func set_alarm() -> ExportOST:
	result[caption] = []
	result = result[caption]
	return self

func set_branch() -> ExportOST:
	result[caption] = {}
	result = result[caption]
	return self

func select(branch: String) -> ExportOST:
	_user = _user[branch]
	path += branch + "/"
	caption = branch
	return self

@onready var _writer: ZIPPacker = ZIPPacker.new()

func manifest(result: Dictionary) -> void:
	print("RESULT: ", result)
	var real: String = JSON.stringify(result, "\t")
	print("REAL: ", real)
	_writer.start_file("music.json")
	_writer.write_file(real.to_utf8_buffer())
	_writer.close_file()

func write(source: String, destination: String) -> void:
	print("WRITING: ", source, " + ", destination)
#	"""
	if FileAccess.file_exists(source):
		print("FILE EXISTS!!!")
		var file: FileAccess = FileAccess.open(source, FileAccess.READ)
		_writer.start_file(destination.replace("user://", ""))
		_writer.write_file(file.get_buffer(file.get_length()))
		_writer.close_file()
		file.close()

func start_write(path: String) -> int:
	return _writer.open(path)

func stop_write() -> void:
	_writer.close()

func append(query: ExportOST, from: Array, to: Array, i: int) -> void:
	to.push_back(query.get_path(from[i]))
	write(from[i], to[i])

func insert(query: ExportOST, from: Dictionary, to: Dictionary, key: String) -> void:
	to[key] = query.get_path(from[key])
	write(from[key], to[key])

func iterate(query: ExportOST, feedback: Callable) -> void:
	query.result.mix = query.context.mix
	query.result.set = []
	var i: int = 0
	while i < query.context.set.size():
		feedback.call(i)
		i += 1



func set_trunks(exporter: Node, query: ExportOST) -> void:
	exporter.selection(query.set_branch().copy().select("type"))#.set_branch())
	exporter.selection(query.copy().select("name"))#.set_branch())

func set_branch(exporter: Node, query: ExportOST) -> void:
	exporter.enumerate(query.set_branch())

func set_alarm(query: ExportOST) -> void:
	var i: int = 1
	query.set_alarm()
	query.result.push_back(query.context[0])
	query.result.push_back(query.get_path(query.context[i]))
	zip.write(query.context[i], query.result[i])

func set_blend(query: ExportOST) -> void:
	query.set_branch()
	query.result.mix = query.context.mix
	query.result.set = {}
	for key in query.context.set:
		zip.insert(query, query.context.set, query.result.set, key)

func set_named(query: ExportOST) -> void:
	query.set_branch()
	for key in query.context:
		zip.insert(query, query.context, query.result, key)

func set_themes(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		zip.append(query, query.context.set, query.result.set, i))

func set_combat(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		var from: Dictionary = query.context.set[i]
		var to: Dictionary = {}
		query.result.set.push_front(to)
		for status in from: zip.insert(query, from, to, status))



@onready var save: SavePresetDialog = $save
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $board
@onready var branch: Node = $branch

func selection(query: ExportOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: ExportOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func _export(path: String) -> void:
	if branch.zip.start_write(path) == OK:
		var query: ExportOST = ExportOST.new()
		query.result = {}
		query.set_user(SoundtrackSystem.user.music)
		query.set_path("")
		enumerate(query)
		branch.zip.manifest(query.result)
		branch.zip.stop_write()

func exporting() -> void:
	save.show_dialog(_export)



extends RefCounted

class_name SoundtrackQuery

var _user: Variant
var caption: String = "initial"

var context: Variant:
	get: return _user



class_name SountrackBranchBehavior

func condition(_data: Variant) -> bool: return true
func branch(_mark: Tick) -> int: return OK

func tick(mark: Tick) -> int:
	if condition(mark.blackboard.get_value("query").context):
		return branch(mark)
	return FAILED





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





extends Node

enum { DROP = 0, ADD = 1, SET = 2, PLAY = 3 }

var _type: int = -1
var type: int:
	get: return _type
	set(value): _type = value

func set_type(i: int) -> void: type = i

func set_leaf_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.pressed.connect(func():
		match type:
			DROP: options.drop.from_theme(entry, leaf)
			ADD: options.add.to_theme(options, entry, leaf)
			SET: options.search.for_theme(entry, leaf)
			PLAY: options.play.as_theme(entry, leaf)
	)

func set_ambient_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	for status in leaf.content:
		leaf.content[status].pressed.connect(func():
			match type:
				DROP: options.drop.from_theme(entry, leaf)
				ADD: options.add.to_ambient(options, entry, leaf)
				SET: options.search.for_ambient(entry, status, leaf)
				PLAY: options.play.as_ambient(entry, status, leaf)
		)

func set_named_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_named(entry, leaf)
			PLAY: options.play.as_named(entry, leaf)
	)

func set_standalone_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_standalone(entry, leaf)
			PLAY: options.play.as_named(entry, leaf)
	)

func set_blend_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_blend(entry, leaf)
			PLAY: options.play.as_blend(entry, leaf)
	)


var theme: OpenThemeDialog

func _theme_select(feedback: Callable) -> void:
	theme.show_dialog(func(track: String):
		SoundtrackSystem.save = true
		feedback.call(track)
	)

func for_theme(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set[ui.i].set_metadata(track)
		entry.theme.set[ui.i] = track
	)

func for_named(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme[event] = track
	)

func for_standalone(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set.set_track_metadata(track)
		entry.theme[1] = track
	)

func for_blend(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme.set[event] = track
	)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set[ui.i].content[status].set_metadata(track)
		entry.theme.set[ui.i][status] = track
	)


func from_theme(entry: Dictionary, ui: Control) -> void:
	SoundtrackSystem.save = true
	var themes: Array = entry.theme.set
	if themes.size() > 1:
		var i: int = ui.i
		var branch: Control = ui.get_parent()
		entry.ui.set.remove_at(i)
		themes.remove_at(i)
		var j: int = themes.size()
		while j > i:
			j -= 1
			entry.ui.set[j].i = j
		branch.remove_child(ui)



var context: OpenThemeDialog

func _add_leaf(entry: Dictionary, kind: Resource, ui: Control) -> Control:
	SoundtrackSystem.save = true
	var list: Array = entry.ui.set
	var leaf: Control = kind.instantiate()
	var i: int = ui.i + 1
	ui.add_sibling(leaf)
	list.insert(i, leaf)
	leaf.i = i
	i = list.size()
	while i > leaf.i:
		i -= 1
		list[i].i = i
	return leaf

func _get_ambient() -> Dictionary:
	var track: String = context.result_file
	return { "ambient": track, "heating": track, "rampage": track }

func to_theme(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, HUD.ost.ui.theme, ui)
	entry.theme.set.insert(leaf.i, context.result_file)
	options.set_leaf_theme(entry, leaf)

func to_ambient(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, HUD.ost.ui.fight, ui)
	entry.theme.set.insert(leaf.i, _get_ambient())
	options.set_ambient_theme(entry, leaf)







extends BehaviorBlackboard

signal progress(value: int)

enum { START = 0, RAMPAGE = 6 } #var _rampage: int = 0 #const LEVEL: int = 4

func reset() -> void:
	s("level", true).s("level_type", START).s("level_name", START)
	s("level_rampage", START).s("rampage", START).s("event", START)
	# set_value("level_event", Vector2i(0, 0)) - TODO level events support
	# x = store first event * LEVEL, y = + rest events
	update_progress()

func update_progress() -> void:
	var event: int = g("event") * RAMPAGE
	var value: int = event + g("rampage") + g("level_rampage")
	progress.emit(value)


signal playback(status: String)

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var change: Node = $change

var started = false

func set_playback(status: String) -> void: playback.emit(status)

func set_menu_context(menu: VBoxContainer) -> void:
	menu.options.back.pressed.connect(save_changes(menu))
	playback.connect(func(status): menu.playback.text = status)
	board.progress.connect(func(value): menu.progress.value = value)

func save_changes(menu: VBoxContainer) -> Callable:
	return func():
		started = false ; player.stop() ; board.reset()
		menu.playback.reset()
		SoundtrackSystem.save_changes()

func pause() -> void: player.stream_paused = true

func play_progress() -> void:
	behavior.tick(self, board)
	board.update_progress()

func start_play() -> void:
	if started:
		player.stream_paused = false #player.play()
	else:
		play_progress()
		started = true

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)
	board.reset()

func as_theme(entry: Dictionary, ui: Control) -> void: change.as_theme(entry, ui)
func as_named(entry: Dictionary, ui: Control) -> void: change.as_named(entry, ui)
func as_blend(entry: Dictionary, ui: Control) -> void: change.as_blend(entry, ui)
func as_ambient(entry: Dictionary, status: String, ui: Control) -> void: change.as_ambient(entry, ui, status)




var _track: String = ""
var _method: Callable

func _load_data(path: String) -> PackedByteArray:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length())

func _load_mp3() -> void:
	var sound: AudioStreamMP3 = AudioStreamMP3.new()
	sound.data = _load_data(_track)
	stream = sound

func _load_ogg() -> void:
	stream = AudioStreamOggVorbis.load_from_file(_track)

func _load_music() -> void:
	# print("LOAD MUSIC")
	_method.call()
	play()

func _get_extension(track: String) -> String:
	var period: int = track.rfind(".")
	return track.substr(period + 1)

func stop_timing() -> void: stop()
func start_timing() -> void: pass

func load_music(track: String) -> int:
	_track = track
	stop_timing()
	match _get_extension(track).to_lower():
		"mp3": _method = _load_mp3
		"ogg": _method = _load_ogg
		_: return ERR_BUSY
	if not FileAccess.file_exists(track):
		return FAILED
	start_timing()
	return OK



extends OSTPlayer

@onready var timing: Timer = $timer

func stop_timing() -> void:
	timing.stop()
	super.stop_timing()

func start_timing() -> void: timing.start()




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




const COMBAT: Dictionary = { "ambient": 0, "heating": 1, "rampage": 2, "absent": 3 }

func from_set(entry: Dictionary, key: Variant) -> Variant: return entry.theme.set[key]
func from_theme(entry: Dictionary, key: Variant) -> Variant: return entry.theme[key]

func no(ui) -> int: return ui.i
func name(ui) -> String: return ui.event.name

func form(status: String, key: Variant, track: String) -> Dictionary:
	var form: Dictionary = { "caption": status, "track": track }
	if key is String: form.name = key
	return key

func play_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.play.call(board, ui)

func select_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.theme.at = ui.i
	play_entry(board, entry, ui)

func an_entry(op: String, entry: Dictionary, ui: Control) -> void:
	get(op + "entry").call(entry, ui)

func an_ost(ost: Variant) -> String:
	return ost.track if ost is Dictionary else ost

func a_status(metadata: Dictionary) -> String:
	if not metadata.has("name"): return metadata.caption
	else: return metadata.name + " - " + metadata.caption

func get_status(player: AudioStreamPlayer, track: String, status: String) -> String:
	match player.load_music(track):
		OK: return status
		FAILED: return track + "? " + tr("MISS") + ": " + status
	return track + " ≠ .mp3, .ogg: " + status

func set_rampage(board: BehaviorBlackboard, status: String) -> void:
	var rampage: int = COMBAT.absent
	if COMBAT.has(status): rampage = COMBAT[status]
	board.set_value("level_rampage", rampage)




extends Node

@onready var level: Node = $level
@onready var world: Node = $world

var menu: VBoxContainer

func switch_mode() -> void: menu.switch_mode()

func setup(options: Node) -> void:
	level.setup(options)
	world.setup(options)

func _feedback(options: Node, type: int, select: Array[String]) -> Callable:
	return func():
		options.operation.set_type(type)
		options.play.get(select.front()).call()
		menu.options.get(select.back()).call()

func feedback_edit(options: Node, type: int) -> Callable:
	return _feedback(options, type, ["pause", "switch_skip"])
	
func feedback_play(options: Node) -> Callable:
	return _feedback(options, options.operation.PLAY, ["start_play", "switch_play"])

func setup_edit_mode(options: Node) -> void:
	var group: Array[Button] = menu.options.mode.edit.options
	for i in len(group):
		group[i].pressed.connect(feedback_edit(options, i))

func set_playback(options: Node, ui: HBoxContainer) -> void:
	ui.play.pressed.connect(feedback_play(options))
	ui.forward.pressed.connect(options.play.play_progress)

func setup_play_mode(options: Node) -> void:
	menu.options.play.restart.pressed.connect(options.play.board.reset)
	set_playback(options, menu.options.mode.play)

func setup_modes(options: Node, ui: VBoxContainer) -> void:
	menu = ui
	setup_edit_mode(options)
	setup_play_mode(options)



extends Node

class_name AmbientOST

@onready var typed: Node = $typed
@onready var named: Node = $named

static func get_ambient() -> Array[String]:
	return ["ambient", "heating", "rampage"]

static func get_level_types() -> Array[String]:
	return ["caves", "temple"]

static func get_level_names() -> Dictionary:
	return {
		"caves": ["origin", "smoke", "sparkling", "ghost"],
		"temple": ["mother"]
	}

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)



extends OSTLeaf

@onready var _types: Array[String] = AmbientOST.get_level_types()

func set_types(options: Node, theme: String, i: int, play: Callable) -> void:
	var type: String = _types[i]
	ost[theme][i] = {
		"ui": options.ui.level[type].type[theme],
		"theme": SoundtrackSystem.user.music.level[type].type[theme],
		"play": play
	}
	set_leaf(options, ost[theme][i])

func set_theme(options: Node, theme: String, play: Callable) -> void:
	ost[theme] = {}
	var i: int = _types.size()
	while i > 0:
		i -= 1
		set_types(options, theme, i, func(b, _u):
			play.call(b, i)
			b.set_value("level", true)
			b.update_progress())

func set_ost(options: Node) -> void:
	ost = {}
	var play: Callable = func(board, i):
		board.set_value("level_type", i)
	set_theme(options, "theme", play)
	play = func(board, i):
		board.set_value("level_type", i)
		board.set_value("level_rampage", 4)
	set_theme(options, "boss", play)



extends OSTLeaf

func get_playback(type: int, level: int) -> Callable:
	return func(board: BehaviorBlackboard, _ui):
		board.set_value("level", true)
		board.set_value("level_type", type)
		board.set_value("level_name", level)
		board.update_progress()

func set_names(options: Node, types: Array[String], i: int) -> void:
	var locations: Dictionary = AmbientOST.get_level_names()
	var type: String = types[i]
	var j: int = locations[type].size()
	while j > 0:
		j -= 1
		var level: String = locations[type][j]
		ost[i][j] = {
			"ui": options.ui.level[type].name[level],
			"theme": SoundtrackSystem.user.music.level[type].name[level],
			"play": get_playback(i, j)
		}
		#print("LOCATION: ", j, " & ", locations[type][j])
		set_leaf(options, ost[i][j])

func set_ost(options: Node) -> void:
	ost = {}
	var types: Array[String] = AmbientOST.get_level_types()
	var i: int = types.size()
	while i > 0:
		i -= 1
		ost[i] = {}
		set_names(options, types, i)




extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named
@onready var weak: Node = $weak

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)
	weak.set_ost(options)


extends OSTLeaf

func set_types(options: Node, themes: Array[String], i: int) -> void:
	var theme: String = themes[i]
	ost[theme] = {
		"ui": options.ui.world[theme].type,
		"theme": SoundtrackSystem.user.music.world[theme].type,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.set_value("rampage", i)
			board.update_progress()
	}
	set_leaf(options, ost[theme])

func set_ost(options: Node) -> void:
	ost = {}
	var themes: Array[String] = ["ambient", "rampage", "boss"]
	var i: int = themes.size()
	while i > 0:
		i -= 1
		ost[themes[i]] = {}
		set_types(options, themes, i)
		
		

extends Node # OSTLeaf

@onready var ambient: Node = $ambient

var ost: Dictionary
var feedback: Dictionary = {
	"rampage": func(ui, options, context):
		options.set_blend_theme(context, ui),
	"boss": func(ui, options, context):
		ui.set_options(options, context)
}

func set_leaf(options: Node, context: Dictionary, theme: String) -> void:
	var ui: Dictionary = context.ui
	for event in ui.set:
		ui.set[event].event.name = event
		feedback[theme].call(ui.set[event], options, context)

func set_types(options: Node, theme: String) -> void:
	ost[theme] = {
		"ui": options.ui.world[theme].name,
		"theme": SoundtrackSystem.user.music.world[theme].name,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[theme], theme)

func set_ost(options: Node) -> void:
	ambient.set_ost(options)
	ost = {}
	for theme in feedback:
		ost[theme] = {}
		set_types(options, theme)



extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named

func set_ost(options: Node) -> void:
	var events: Array[String] = ["town", "scene"]
	typed.set_ost(events, options)
	named.set_ost(events, options)

extends OSTLeaf

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].type,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].type,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)


extends Node # OSTLeaf

var ost: Dictionary

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
#	var i: int = ui.set.size()
	for event in ui.set:
#	while i > 0:
#		i -= 1
#		ui.set[i].i = i
		ui.set[event].event.name = event
		ui.set[event].set_options(options, context)

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].name,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].name,
		"play": func(board: BehaviorBlackboard, ui: Control):
			board.set_value("level", false)
			board.set_value("rampage", 0)
			board.set_value("event", ui.event.id)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)



extends OSTLeaf

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	# ui.set.event.name = "weak"
	ui.set.set_options(options, context)

func set_ost(options: Node) -> void:
	ost = { 
		"ui": options.ui.world.weak,
		"theme": SoundtrackSystem.user.music.world.weak,
		"play": func(_b, _u): pass
	}
	set_leaf(options, ost)




extends Node

class_name OSTLeaf

var ost: Dictionary

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		ui.set[i].i = i
		ui.set[i].set_options(options, context)





extends BehaviorAction

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.get_value("level") else FAILED

extends BehaviorSelector

func set_ost(music: Node) -> void:
	for dungeon in get_children():
		dungeon.set_ost(music)


extends BehaviorSequence

@onready var dungeon: BehaviorSelector = $dungeon

func set_ost(music: Node) -> void:
	dungeon.set_ost(music)





extends BehaviorSelector

func set_dungeons(feedback: Callable) -> void:
	for dungeon in get_children():
		feedback.call(dungeon)


extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var levels: BehaviorSelector = $levels

@export var type: int = 0

func _ready() -> void:
	check.type = type
	levels.set_dungeons(func(l): l.type = type)

func set_ost(music: Node) -> void:
	levels.set_dungeons(func(l): l.set_ost(music))


extends BehaviorAction

var type: int = 0

func tick(mark: Tick) -> int:
	var value = mark.blackboard.get_value("level_type")
	return OK if value == type else FAILED




extends BehaviorAction

var caption: int = 0

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	return OK  if mark.blackboard.compare(key, caption) else FAILED



extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.set_value("level", false)
	mark.blackboard.set_value("rampage", 0)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK


extends BehaviorSequence

@onready var theme: BehaviorSelector = $theme

@export_category("Level")
@export var caption: int = 0
@export var boss_fight: String = ""

var type: int:
	set(value): theme.ambient.type = value

func _ready() -> void:
	$assert.caption = caption
	theme.ambient.caption = caption
	theme.boss.level_boss = boss_fight

func set_ost(music: Node) -> void:
	theme.set_ost(music)



extends BehaviorSelector

@onready var ambient: BehaviorSelector = $ambient
@onready var boss: BehaviorSequence = $boss

var boss_fight: String:
	set(value): boss.level_boss = value

func set_ost(music: Node) -> void:
	ambient.set_ost(music)
	boss.set_ost(music)



extends AmbientPlaybackAssert

var has_boss: bool = false

func compare(board: BehaviorBlackboard) -> bool:
	return has_boss and board.compare(key, rampage)

extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 3

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

var _caption: String

var level_boss: String:
	set(value):
		_caption = value
		$assert.has_boss = value != ""
		$assert.rampage = RAMPAGE

func set_ost(music: Node) -> void:
	theme.set_ost(music, _caption)

func _ready() -> void:
	theme.connect_rampage(check)




extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_ost(music: Node, caption: String) -> void:
	named.set_ost(music, caption)
	typed.set_ost(music)

func connect_rampage(check: Node) -> void:
	for action in [named, typed.level, typed.world]:
		action.progress.connect(check.add_rampage)


extends BehaviorActionPlayback

signal progress(mark: Tick)

var _caption: String

func set_ost(music: Node, caption: String) -> void:
	_caption = caption
	_ost = music.world.named.ost.boss

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[_caption])

func tick(mark: Tick) -> int:
	if _caption != "" and _ost.theme.has(_caption) and _ost.theme[_caption] != "":
		set_track(mark)
		progress.emit(mark)
		# mark.actor.player.load_music(_ost[_caption])
		return OK
	return FAILED




extends BehaviorSelector

@onready var level: BehaviorAction = $level
@onready var world: BehaviorAction = $world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)


extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.boss[type]

func tick(mark: Tick) -> int:
	if _ost.theme.set.size() > 0:
		var result = super.tick(mark)
		progress.emit(mark)
		#mark.actor.player.load_music(track)
		return result
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	super.tick(mark)
	progress.emit(mark)
	return OK





extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int = 0

var type: int:
	set(value): theme.named.type = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void:
	theme.status = name
	check.rampage = rampage
	theme.connect_rampage(check)

func set_ost(music: Node) -> void:
	theme.set_ost(music)



extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var caption: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.named.ost[type][caption]
	#_ost.ui.set[0].get_node("../../head/mix").safe_connect(_ost)

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if _ost.theme.has("mix") and _ost.theme.mix and mark.blackboard.compare(key, caption):
		# mark.actor.player.load_music(get_track(status))
		mark.blackboard.set_value(key, caption + 1)
		return super.tick(mark)
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.theme[type]
	#_ost.ui.set[0].get_node("../../head/mix").safe_connect(_ost)

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)


extends BehaviorActionPlayback

const MAX: int = 100

func probable(mix: int) -> bool:
	return mix != 0 and (mix == MAX or randi_range(_ost.mix, MAX) == MAX)

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(_ost.set.ray)

func get_ost(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ui": options.ui.world.rampage.name,
		"ost": SoundtrackSystem.user.world.rampage.name
	}

func tick(mark: Tick) -> int:
	if probable(_ost.mix):
		_set_track(mark)
		return OK
	return FAILED




extends BehaviorAction

class_name BehaviorActionPlayback

var _ost: Variant

static func get_default_progress() -> Dictionary:
	return {
		"level": { "active": false, "name": 0, "type": 0 },
		"rampage": 0, "event": 0
	}

func get_track() -> Control:
	var at: int = 0
	if _ost.theme.has("at"):
		at = _ost.theme.at
	var size: int = _ost.theme.set.size()
	if _ost.theme.mix:
		var next: int = randi_range(at, at + size - 1)
		at = (next + 1) % size
	else:
		at = (at + 1) % size
	_ost.theme.at = at
	return _ost.ui.set[at]

func _set_track(mark: Tick) -> void:
	mark.actor.as_theme(_ost, get_track())
	# mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK



extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

var status: String:
	set(value):
		named.status = value
		typed.status = value

func connect_rampage(check: BehaviorAction) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)

func set_ost(music: Node) -> void:
	named.set_ost(music)
	typed.set_ost(music)



extends BehaviorAction

class_name AmbientPlaybackAssert

var rampage: int = 0
var key: String = "level_rampage"

func compare(board: BehaviorBlackboard) -> bool:
	return board.compare(key, rampage)

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, rampage + 1)

func tick(mark: Tick) -> int:
	if compare(mark.blackboard):
		# mark.blackboard.set_value(key, rampage + 1)
		return OK
	return FAILED





extends BehaviorSelector

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]

var caption: int:
	set(value): set_ambient(func(a): a.caption = value)
var type: int:
	set(value): set_ambient(func(a): a.type = value)

func set_ambient(feedback: Callable) -> void:
	for status in rampage:
		feedback.call(status)

func set_ost(music: Node) -> void:
	set_ambient(func(a): a.set_ost(music))




@tool
extends BehaviorTree

@onready var level: BehaviorSequence = $location/level
@onready var world: BehaviorSelector = $location/world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)




extends BehaviorAction

const RAMPAGE: int = 1
var key: String = "rampage"

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, RAMPAGE + 1)

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.compare(key, RAMPAGE) else FAILED



extends BehaviorSelector

@onready var hero: BehaviorAction = $hero
@onready var typed: BehaviorAction = $typed

func set_for(feedback: Callable) -> void:
	for action in [hero, typed]:
		feedback.call(action)

func set_ost(music: Node) -> void:
	set_for(func(a): a.set_ost(music))

func connect_rampage(check: Node) -> void:
	set_for(func(a): a.progress.connect(check.add_rampage))



extends BehaviorActionPlayback

class_name HeroBattleTheme

signal progress(mark: Tick)

enum { MIN = 0, MAX = 100 }

func set_ost(music: Node) -> void:
	_ost = music.world.named.ost.rampage

func _compare(mix: int) -> bool:
	var value: int = randi_range(MIN, MAX)
	return MIN <= value and value < mix

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or _compare(mix))

func tick(mark: Tick) -> int:
	if probable(_ost.theme.mix):
		#mark.actor.player.load_music(_ost.set.values().pick_random())
		#var result = super.tick(mark)
		#progress.emit(mark)
		var hero: String = ["ray", "rock"].pick_random()
		mark.actor.as_blend(_ost, _ost.ui.set[hero])
		progress.emit(mark)
		return OK
	return FAILED



extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.rampage

func set_track(mark: Tick) -> void:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	#mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	set_track(mark)
	return OK



extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

func set_ost(music: Node) -> void:
	theme.set_ost(music)

func _ready() -> void:
	theme.connect_rampage(check)




extends BehaviorSelector

func set_ost(music: Node) -> void:
	var events: Array[Node] = get_children()
	var i: int = events.size() - 1
	while i > 0:
		i -= 1
		events[i].set_ost(music, i)


class_name BehaviorLevelProgress extends BehaviorAction

static func get_dungeons() -> Array[Vector2i]:
	return [
		Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2),
		Vector2i(0, 3), Vector2i(1, 0)
	]

func set_dungeon(board: BehaviorBlackboard, dungeon: Vector2i) -> void:
	board.set_value("level_type", dungeon.x)
	board.set_value("level_name", dungeon.y)

func set_progress(board: BehaviorBlackboard) -> void:
	var dungeons: Array[Vector2i] = get_dungeons()
	var progress: int = (board.get_value("event") + 1) % dungeons.size()
	
	set_dungeon(board, dungeons[progress])
	board.set_value("level", true)
	board.set_value("event", progress)
	board.set_value("rampage", 0)
	board.set_value("level_rampage", 0)


extends BehaviorLevelProgress

const EVENT: int = 0

func tick(mark: Tick) -> int:
	set_progress(mark.blackboard)
	mark.blackboard.set_value("event", EVENT)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK





extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.add_value("event", 1)
	return OK



extends BehaviorAction

@export var event: int = 0

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.compare("event", event) else FAILED



extends BehaviorAction

signal progress(mark: Tick)

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	_ost = music.world.named.ambient.named.ost.scene
	_ost.ui.set[caption].event.id = event

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.theme.has(caption) and _has_access(_ost.theme[caption]):
		set_track(mark)
		progress.emit(mark)
		return OK
	return FAILED



extends BehaviorAction

signal progress(mark: Tick)

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	_ost = music.world.named.ost.boss
	_ost.ui.set[caption].event.id = event

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.theme.has(caption) and _has_access(_ost.theme[caption]):
		set_track(mark)
		progress.emit(mark)
		return OK
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	# mark.actor.player.load_music(get_track())
	return OK




extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.ost.scene

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	# mark.actor.player.load_music(get_track())
	return OK



extends BehaviorAction

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	var town: Dictionary = music.world.named.ambient.named.town
	town.ui.set[caption].event.id = event
	_ost = town.theme

func set_track(player: AudioStreamPlayer) -> void:
	player.load_music(_ost[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.has(caption) and _has_access(_ost[caption]):
		set_track(mark.actor.player)
		return OK
	return FAILED




extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.town

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	# mark.actor.player.load_music(get_track())
	return FAILED




extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

func set_ost(music: Node, event: int, caption: String) -> void:
	named.caption = caption
	named.set_ost(music, event)
	typed.set_ost(music)

func connect_rampage(check) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)



extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var event: int = 0

func set_ost(music: Node, _event: int) -> void:
	theme.set_ost(music, _event, name)

func _ready() -> void:
	check.event = event
	theme.connect_rampage(check)




extends BehaviorLevelProgress

class_name BehaviorActionEvent

var event: int = 0
var key: String = "event"

func add_rampage(mark: Tick) -> void:
	set_progress(mark.blackboard)

func tick(mark: Tick) -> int:
	print("EVENT: ", get_parent().name)
	if mark.blackboard.compare(key, event):
		return OK
	return FAILED


extends BehaviorActionPlayback

const RAMPAGE: int = 0

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.ambient

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if mark.blackboard.compare(key, RAMPAGE):
		mark.actor.as_theme(_ost, get_track())
		# mark.actor.player.load_music(get_track())
		mark.blackboard.set_value(key, RAMPAGE + 1)
		return OK
	return FAILED




extends BehaviorSelector

func set_ost(music: Node) -> void:
	for dungeon in get_children():
		dungeon.set_ost(music)





extends RichTextLabel

var _placeholder: String

func _ready() -> void:
	_placeholder = text

func reset() -> void:
	text = _placeholder

@onready var settings: Control = $ost/settings
@onready var options: Control = $options
@onready var playback: RichTextLabel = $playback/status
@onready var dropdown: HFlowContainer = $ost/scroll/margin/dropdown
@onready var progress: ProgressBar = $progress
@onready var soundtrack: VBoxContainer = $margin/soundtrack

func switch_mode() -> void:
	settings.tabs.switch_mode()
	options.switch_mode()


class_name OpenPresetDialog

var _feedback: Callable
var result_file: String = ""

func _ready() -> void:
	file_selected.connect(selected)

func selected(file: String) -> void:
	if FileAccess.file_exists(file):
		result_file = file
		_feedback.call(file)
	else:
		result_file = ""

func show_dialog(feedback: Callable) -> void:
	_feedback = feedback
	show()

class_name SavePresetDialog

func selected(file: String) -> void:
	result_file = file
	_feedback.call(file)



extends VBoxContainer

# @onready var music: Button = $music
# @onready var sound: Button = $sound
@onready var play: Button = $play
@onready var edit: Button = $edit

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)


extends VBoxContainer

@onready var reset: Button = $reset
@onready var importer: Button = $importer
@onready var exporter: Button = $exporter


extends Control

@onready var info: VBoxContainer = $info
@onready var tabs: VBoxContainer = $tabs







extends HBoxContainer

@onready var copy: Button = $copy
@onready var restart: Button = $restart

func _toggle(state: bool) -> void:
	copy.visible = !state
	restart.visible = state

func switch_mode() -> void: _toggle(copy.visible)


extends HBoxContainer

@onready var backward: Button = $backward
@onready var play: Button = $play
@onready var pause: Button = $play
@onready var forward: Button = $forward

var options: Array[Button]:
	get: return [backward, play, pause, forward]

func _toggle(state: bool) -> void:
	pause.visible = state
	play.visible = !state

func switch_skip() -> void:
	if !play.visible: _toggle(false)

func switch_play() -> void: _toggle(true)


extends HBoxContainer

@onready var edit: HBoxContainer = $edit
@onready var play: HBoxContainer = $play

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)



extends HBoxContainer

@onready var drop: Button = $drop
@onready var add: Button = $add
@onready var search: Button = $search

var options: Array[Button]:
	get: return [drop, add, search]



extends HBoxContainer

@onready var back: Button = $back
@onready var restart: Button = $restart



extends Control

@onready var home: HBoxContainer = $home
@onready var mode: HBoxContainer = $mode
@onready var play: HBoxContainer = $play

func switch_skip() -> void: mode.play.switch_skip()
func switch_play() -> void: mode.play.switch_play()
func switch_mode() -> void:
	mode.switch_mode()
	play.switch_mode()





@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

@export var path: String = "../../.."

var _ui_caption: String

var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = _ui_caption

func _ready() -> void:
	var title: Control = get_node(path)
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	pad.visible = toggled_on
	content.visible = toggled_on



@onready var open: Control = $open
@onready var close: Control = $close

func set_active(expanded: bool) -> void:
	open.visible = !expanded
	close.visible = expanded




extends Button

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

var _ui_caption: String

var title: Control
var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = value

func _ready() -> void:
	title = get_node("../../../..")
	pad = title.get_node("../pad")
	content = title.get_node("body")

func _toggled(toggled_on: bool) -> void:
	# short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on



class_name SoundtrackLeaf extends Button

@onready var metadata: Label = $metadata

var i: int
var caption: String = ""

func set_metadata(track: String) -> void:
	var slash: int = track.rfind("/") + 1
	var path: String = track.replace("\\", "/").substr(slash)
	var dot: int = path.rfind(".")
	caption = path.substr(0, dot)
	metadata.text = track
	text = caption

func set_track_authority(ui_track: String) -> void:
	metadata.text = ui_track
	text = ui_track + "_metadata"

func set_options(options: Node, context: Dictionary) -> void:
	options.set_leaf_theme(context, self)



extends HBoxContainer

@onready var content: Dictionary = {
	"ambient": $content/ambient,
	"heating": $content/heating,
	"rampage": $content/rampage
}

var i: int
var event: int

func set_options(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context, self)



extends Button

@onready var caption: Label = $margin/caption

func _toggled(toggled_on: bool) -> void:
	set_metadata(toggled_on)

func set_metadata(status: bool) -> void:
	caption.text = "📢" if status else "🔇"


extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value): content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

func connect_mix(ost: Dictionary) -> void:
	content.head.mix.safe_connect(ost)


extends VBoxContainer

@onready var head: HBoxContainer = $head
@onready var body: VBoxContainer = $body

var caption: String:
	set(value):
		head.caption = value


extends HBoxContainer

@onready var named: Button = $named

var caption: String:
	set(value):
		named.caption = value



extends Node

@onready var themes: VBoxContainer = $themes
@onready var slider: VSlider = $mix

var caption: String:
	set(value):
		themes.head.caption = value

func set_metadata(mix: int) -> void:
	slider.value = mix
	themes.head.set_metadata(mix)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	slider.value_changed.connect(func(s): ost.mix = s)
	slider.value = clampi(ost.mix, 0, 100)
		#button_pressed = ost.mix
		#set_metadata(ost.theme.mix)
	#	_connected = true




extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value): content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

#func set_metadata(mix: int) -> void:
#	content.set_metadata(mix)

func connect_mix(ost: Dictionary) -> void:
	content.safe_connect(ost)



extends Button

@onready var caption: VBoxContainer = $margin/caption
@onready var slider: VSlider = get_node("../../../mix")

func _ready() -> void:
	slider.value_changed.connect(set_metadata)
	
func _toggled(toggled_on: bool) -> void:
	slider.visible = toggled_on

func set_metadata(mix: int) -> void:
	caption.status.text = str(mix)


extends VBoxContainer

@onready var status: Label = $status
@onready var mix: Label = $mix




extends HBoxContainer

@onready var named: Button = $named
@onready var mix: Button = $mix

var caption: String:
	set(value):
		named.caption = value

func set_metadata(value: int) -> void:
	mix.set_metadata(value)



extends HBoxContainer

@onready var named: Button = $named
@onready var mix: Button = $mix

var caption: String:
	set(value):
		named.caption = value

func set_metadata(value: bool) -> void:
	mix.set_metadata(value)


extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value):
		content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

#func set_metadata(mix: bool) -> void:
#	content.set_metadata(mix)

func connect_mix(ost: Dictionary) -> void:
	content.head.mix.safe_connect(ost)


extends Node

@onready var head: BoxContainer = $head
@onready var body: BoxContainer = $body

var caption: String:
	set(value):
		head.caption = value

#func set_metadata(mix: bool) -> void:
#	head.set_metadata(mix)



extends VBoxContainer

@onready var status: Label = $status
@onready var mix: Label = $mix



extends Button

@onready var caption: VBoxContainer = $margin/caption

#var _connected: bool = false

func _toggled(toggled_on: bool) -> void:
	print("TOGGLE")
	set_metadata(toggled_on)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	toggled.connect(func(s): ost.mix = s)
	button_pressed = ost.mix
	#set_metadata(ost.theme.mix)
	#_connected = true

func set_metadata(status: bool) -> void:
	caption.status.text = "V" if status else "X"




extends HBoxContainer

@onready var leaf: Button = $leaf
@onready var active: Button = $active

var event: Dictionary = { "id": 0, "name": "" }

func set_track_metadata(track: String) -> void:
	leaf.set_metadata(track)

func set_metadata(track: Array) -> void:
	active.set_metadata(track[0])
	set_track_metadata(track[1])

func set_track_authority(ui_track: String) -> void:
	leaf.set_track_authority(ui_track)

func set_options(options: Node, context: Dictionary) -> void:
	options.set_standalone(context, self)

func set_feedback(feedback: Callable) -> void:
	leaf.pressed.connect(feedback)




extends SoundtrackLeaf

@onready var title: Label = $title/caption

var event: Dictionary = { "id": 0, "name": "" } # var event: String

func set_title(entity: String) -> void:
	title.text = entity

func set_options(options: Node, context: Dictionary) -> void:
	options.set_named_theme(context, self)

func set_feedback(feedback: Callable) -> void:
	pressed.connect(feedback)



extends Button

@onready var short: Control = $short

var pad: Control
var content: Control

func _ready() -> void:
	var title: Control = get_node("../../..")
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on
