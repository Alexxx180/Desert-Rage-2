class_name Menu extends RefCounted

enum { PAUSE, GAME }

var no: int = 0
var card: Button
var state: int = 0

var navigation: Array
var hints: CompressedTexture2DArray = preload("res://icon/help/z_master.svg")
var _pause: Control ; var _game: Control ; var _settings: Control ; var _sound: Control ; var _information: Control

var game: Control:
	get: return connect_menu(_game, Def.game, &"_game")
var pause: Control:
	get: return connect_menu(_pause, Def.pause, &"_pause")
var settings: Control:
	get: return connect_menu(_settings, Def.settings, &"_settings")
var information: Control:
	get: return connect_menu(_information, Def.information, &"_information")
var sound: Control:
	get: return connect_menu(_sound, Def.sound, &"_sound")

func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		var last: bool = n.hud.logic.is_opened_last
		result = result and (not last)
	return not result

func connect_menu(node: Control, path: StringName, caption: StringName) -> Control:
	if node != null: return node
	node = Def.lazy(HUD, node, path, caption)
	match node.name:
		&"game": pass
		&"pause":
			node.options.resume.connect(pause_resume)
			node.options.saves.connect(func(): toggle_menu(HUD.saves))
			node.options.settings.connect(func(): toggle_menu(HUD.settings))
			node.options.main.connect()
		&"saves": HUD.saves.back.connect(_resume_level)
		&"sound": HUD.sound.back.connect(sound_back)
		&"settings":
			settings = node
			settings.back.connect(_resume_level)
			settings.sound.connect(sound_show)
	return node

func sound_show() -> void: _sound_level(false, Node.PROCESS_MODE_INHERIT)
func sound_back() -> void: _sound_level(true, Node.PROCESS_MODE_DISABLED)

func _sound_level(pause: bool, mode: Node.ProcessMode) -> void:
	HUD.sound.visible = !pause
	if PAUSE:
		HUD.settings.visible = pause
	else:
		set_level_mode(mode)

func _pause_level(pause: bool, mode: Node.ProcessMode) -> void:
	if PAUSE:
		HUD.pause.visible = pause
	else:
		set_level_mode(mode)

func _resume_level() -> void:
	HUD.level.show()
	HUD.game.show()
	_pause_level(true, Node.PROCESS_MODE_INHERIT)

func toggle_menu(menu: Control) -> void:
	menu.show()
	HUD.level.hide()
	_pause_level(false, Node.PROCESS_MODE_DISABLED)

func main_menu() -> void:
	HUD.pause.hide()
	HUD.stats.tree.change_scene_to_file(Def.main_menu)

func pause_set() -> void: _pause_toggle(true, Node.PROCESS_MODE_DISABLED)
func pause_resume() -> void: _pause_toggle(false, Node.PROCESS_MODE_INHERIT)
func _pause_toggle(next: bool, mode: Node.ProcessMode) -> void:
	HUD.pause.visible = next
	set_level_mode(mode)

func set_level_mode(mode: Node.ProcessMode) -> void: HUD.level.process_mode = mode

func upload_help() -> void:
	HUD.game.hints.motion.texture = ImageTexture.create_from_image(hints.get_layer_data(no))

func log_help_hide() -> void:
	var tween: Tween = HUD.create_tween()
	tween.tween_property(card, ^"modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(card.hide)

func log_help(of: int) -> void:
	if card == null:
		card = load(Def.card).instantiate()
		game.help.add_child(card)
	card.show()
	var tween: Tween = game.create_tween()
	tween.tween_property(card, ^"modulate", Color.WHITE, 1)
	card.text = tr("H" + Def.hints[of] + "T") + card.MARGIN
	card.help.text = "H" + Def.hints[of] + "D"
	
"""


enum { IS_FULL }

var logs: PackedScene
var text: PackedStringArray = ["Полегче с этим."]

func add_log(caption: String) -> void:
	var line: Label = logs.instantiate()
	HUD.game.log.add_child(line)
	line.text = caption

func notify(type: int) -> void: add_log(text[type])







const DURATION: float = 0.5
const DELAY: float = 0.15

var scene: String

func set_ledge_color(ledges: Control, target: Color) -> void:
	for l in ledges.get_children(): l.color = target

func as_way(way: ColorRect, target: Color, end: bool = false) -> void:
	var tween: Tween = way.create_tween()
	tween.tween_property(way, "modulate", target, DELAY)
	if end: tween.tween_callback(func(): end_transition(way))

func as_ledges(ledges: Control, target: Color = Color.BLACK, end: bool = false) -> void:
	var tween: Tween = ledges.create_tween()
	tween.set_parallel(true)
	for i in 3:
		var delay: float = DELAY * i
		var ledge: ColorRect = ledges.get_node("ledge_%d" % (i + 1))
		tween.tween_property(ledge, "modulate", target, DURATION - delay).set_delay(delay)
	if end: tween.tween_callback(func(): end_transition(ledges))

func end_transition(logic: Node) -> void:
	print_debug(logic.get_tree().call_deferred("change_scene_to_file", scene))




func set_color(target: Color) -> void:
	for i in get_children():
		i.color = target

func _transit(target: Color = Color.BLACK) -> Tween:
	var tween: Tween = create_tween()
	for i in 3:
		var delay: float = DELAY * i
		tween.tween_property(get_node("ledge_%d" % (i + 1)), "modulate", target, DURATION - delay).set_delay(delay)
	return tween



enum { WAY = 0, LEDGE = 1 }

var blackout: BlackoutTransition = BlackoutTransition.new()
var _ledges: ColorRect = null
var ledges: ColorRect:
	get: return Def.lazy(self, _ledges, Def.ledges, "ledges")

func entry_way() -> void: # way.color = Color.BLACK
	blackout.as_way(self, Color.TRANSPARENT, true)

func entry_ledges() -> void:
	blackout.set_color(Color.BLACK)
	blackout.as_ledges(ledges, Color.TRANSPARENT, true)
	color = Color.TRANSPARENT

func entry_transit(type: int) -> void:
	match type:
		WAY: entry_way()
		LEDGE: entry_ledges()

func start_transition(level: String, _floor_diff: int = 0, type: int = LEDGE) -> void:
	blackout.scene = level
	match type:
		WAY: blackout.as_way(self, Color.BLACK, true)
		LEDGE: blackout.as_ledges(ledges, Color.BLACK, true)



extends Node

enum { EMPTY = 0, KNIFE = 1 }

@onready var preview: Timer = $preview
@onready var panel: Timer = $panel

var inventory: Array = []
var markers: HFlowContainer

var showed: bool = false
var selection: int = 0
var mask: Array[int] = [0, 2]
var items: Array[int] = [EMPTY, EMPTY, KNIFE, EMPTY, EMPTY]

static func cline(value: int, length: int) -> int:
	return length + value if value < 0 else value % length

func _toggle_selection(a: int, b: int) -> void:
	markers.items[a].hide_item()
	markers.items[b].show_item()
	for element in inventory:
		element.primary[a].hide_selection()
		element.primary[b].show_selection()

func _fast_panel_selection(offset: int) -> void:
	if not showed:
		showed = true
		for item in markers.items: item.stand.show()

	var length: int = mask.size()
	var next: int = cline(selection + offset, length)

	_toggle_selection(mask[selection], mask[next])
	preview.start()
	panel.start()
	selection = next

func hide_preview() -> void:
	pass
	# markers.items[mask[selection]].preview.hide()

func hide_items() -> void:
	showed = false
	for item in markers.items: item.stand.hide()

func _input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("item_select"):
		return
	var axis: float = Input.get_axis("item_left", "item_right")
	if axis != 0: _fast_panel_selection(roundi(axis))

"""




@onready var timer: Timer = $timer

var level: int = 0
var cursor: int = 0
var backlog: int = 0

var block: Node
var queue: Array[int] = []
var talking: bool:
	get: return not queue.is_empty()
var chat: int:
	get: return queue.pop_front()

func set_level(value: int, position: int) -> void: # LEVEL USUALLY set after level finish or on load
	level = value
	cursor = position # locale.get_chat(value)
	backlog = cursor - 1

func scroll(locale: Node) -> void:
	if backlog == -1: return

	for i in range(5):
		if not locale.with(backlog, "L"):
			backlog = -1 ; break
		var key: String = locale.text(backlog)
		block.insert_chat(block.chat(key), block.chat(key))
		backlog -= 1

func find_part(locale: Node, key: String) -> int:
	var i: int = cursor
	while not locale.with(i, key): i += 1
	return i

func add_queue(locale: Node, key: String) -> void:
	var i: int = find_part(locale, key)
	while locale.with(i, key):
		queue.append(i)
		i += 1




var length: int = 0
var locale: Node
var nodes: Array = []

var who: Dictionary = { "R": "RAY", "K": "ROCK", "D": "DID", "Q": "???" }
var face: Dictionary = {
	"L": "look", "R": "rage", "G": "grin", "S": "smile", "C": "confirm",
	"T": "tired", "B": "but", "N": "sign", "A": "amaze", "P": "respect",
	"E": "anger", "Y": "play", "I": "rain", "W": "scare"
}

func _dialog_level(value: int) -> void: cursor.set_level(value, locale.get_chat(value))
func _scroll() -> void: scroll(locale)
func _ready() -> void: timer.timeout.connect(talking)

func add_chat(part: int) -> void:
	var key: String = "L%d_%d" % [cursor.level, part]
	cursor.add_queue(locale, key)
	timer.start()

func get_chatter(key: String) -> Dictionary:
	var alias: String = key[-2]
	assert(face.has(key[-1]), "Unknown emotion: %s" % key)
	assert(who.has(alias), "Unknown character: %s" % key)
	return { "face": face[key[-1]], "who": who[alias], "alias": alias }

func _new_chat_block() -> void:
	var key: String = locale.text(cursor.chat)
	var id: Dictionary = get_chatter(key)
	clear()
	length = len(tr(key)) ; nodes.clear()
	cursor.block.chats(id.who, nodes, key, 3)
	cursor.block.add_chat(nodes)
	cursor.block.set_emotion(id)

func plot_speech() -> void:
	for node in nodes: node.visible_characters += 1
	length -= 1

func clear() -> void: for node in nodes: node.visible_characters = -1

func stop_speech() -> void:
	clear()
	cursor.block.hide_emotion()
	timer.stop()

func talking() -> void:
	if length > 0:
		plot_speech()
	elif cursor.talking:
		_new_chat_block()
	else:
		stop_speech()





var _locale: Array = Def.ARRAY
var locale: Array:
	get:
		if _locale == Def.ARRAY: _locale = _get_locale()
		return _locale

func text(cursor: int) -> String: return locale[cursor]
func with(cursor: int, start: String) -> bool:
	return locale[cursor].begins_with(start)

func _get_locale() -> Array: # TODOT
	var result: Array = [] # for loc in TranslationServer.get_loaded_locales():
	var translation: Translation = TranslationServer.get_translation_object("en")
	if translation:
		var message: PackedStringArray = translation.get_message_list() # get_all_scripts()
		result.append_array(message)
	return result

func search_entry(entry: String) -> int:
	var res: int = Def.INT
	var size: int = len(locale)
	var cr: Array = [[1, 2], [size - (size % 2), -2]]
	while (cr[0][0] < size) and (cr[1][0] > 0) and (res == Def.INT):
		for c in cr:
			if with(c[0], entry): res = c[0]
			c[0] += c[1]
	return res

func align_cursor(res: int, entry: String) -> int:
	assert(res != Def.INT, "Level localization not found")
	while (res != Def.INT and with(res, entry)): res -= 1
	res += 1
	return res

func get_chat(level: int) -> int:
	var entry: String = "L%d" % level
	return align_cursor(search_entry(entry), entry)



func chat(who: String, key: String):
	var statement: Label = PreloadBus.chat.instantiate()
	statement.say(who, key)
	return statement

func chats(who: String, result: Array, key: String, count: int) -> void:
	for i in range(count): result.append(chat(who, key))

func insert_chat(h: Label, p: Label) -> void:
	hud.chat.insert(h)
	panel.insert(p) # .chat

func add_chat(nodes: Array) -> void:
	hud.temp.chat.append(nodes[0])
	hud.chat.append(nodes[1]) # add_child
	panel.append(nodes[2]) # chat

func hide_emotion() -> void: for e in emotion: e.hide_animation()
func set_emotion(id: Dictionary) -> void:
# id.alias.to_lower()
	for e in emotion: e.set_animation('r' + "_" + id.face)




signal update()

# var _ui: SoundtrackUI
# var ui: SoundtrackUI:
	# get: return Def.ref(self, _ui, &"_ui", new_soundtrack_ui)
var _json: Dictionary = {
	"COPY": "res://asset/resource/media/ost/%s.json",
	"USER": "user://%s.json"
}
# func new_soundtrack_ui() -> SoundtrackUI: return SoundtrackUI.new()

var save: bool = false
var _copy: Dictionary = { "music": {} }
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

func _ready() -> void: reimport()

func reset() -> void: _init_vault("music", true)

func reimport() -> void: _init_vault("music")

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




@export var is_overworld: bool = false
@onready var players: Array[AudioStreamPlayer] = [$a, $b]
@onready var tension: Node = $tension
@onready var mixer: Node = $mixer

const DURATION: float = 0.5

var current: int = 0
var player: AudioStreamPlayer:
	get: return players[current]

var _set_previous: Callable
var _get_record: Callable

func _set_level_type(previous: Callable, record: Callable) -> void:
	_set_previous = previous
	_get_record = record

func fade_track(that: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(that, "volume_db", -80.0, DURATION)
	tween.tween_property(players[_fade_next()], "volume_db", 0.0, DURATION)
	tween.tween_callback(func(): that.stop() ; _end_fade())

func ready() -> void:
	if is_overworld:
		_set_level_type(_set_previous_world, func(): return mixer.record)
	else:
		_set_level_type(_set_previous_dungeon, func(): return mixer.record[tension.state])
	mixer.is_overworld = is_overworld
	mixer.ost.update.connect(set_tracks)
	tension.change_danger.connect(set_playback)

func set_tracks() -> void:
	mixer.set_tracks.call()
	next_playback(true)

func next_playback(finished: bool = false) -> void:
	mixer.next_track()
	set_playback(finished)

func load_music(track: String) -> void: player.load_music(track)

func _set_previous_dungeon() -> void:
	var previous = mixer.record[tension.previous_state] # FOR DUNGEON
	if not previous is Dictionary:
		mixer.record[tension.previous_state] = {
			"track": previous, "position": player.get_playback_position() }
	else:
		previous.position = player.get_playback_position()

func _set_previous_world() -> void: pass

func set_playback(finished: bool) -> void:
	_set_previous.call() # _set_previous_world()
	if not finished:
		
		_start_fade()
	else:
		_end_fade()

func _fade_next() -> int: return (current + 1) % players.size()
func _start_fade() -> void:
	if player.playing: fade_track(player)
	current = _fade_next()

func _end_fade() -> void:
	player.set_record_playback(_get_record.call())

func _finished() -> void:
	var record: Variant = _get_record.call()
	if record is Dictionary: record.position = 0.0
	next_playback(true)





var caption: String = "origin"
var i: int = 0
var music: Array
var _mixed: bool = false
var set_tracks: Callable

var record: Variant:
	get: return music[i]
var ost: SoundtrackSystem
var is_overworld: bool:
	set(value):
		set_tracks = set_world_tracks if value else set_dungeon_tracks

func _set_number(tracks: Dictionary) -> void:
	i = tracks.at if tracks.has("at") else 0

func set_track(track: Dictionary) -> void:
	music = track.set
	_set_number(track)

func _has_level(_ost: Dictionary) -> bool:
	return _ost.name.has(caption) and _ost.name[caption].mix
# func set_tracks(ost: Dictionary) -> void: pass

func set_world_tracks() -> void:
	set_track(ost.user.music.world.ambient.type)
	# _mixed = ost.type.theme.mix

func set_dungeon_tracks() -> void:
	var _ost: Dictionary = ost.user.music.level.caves
	_mixed = _ost.type.theme.mix
	if _has_level(_ost):
		set_track(_ost.name[caption])
	else:
		set_track(_ost.type.theme)

func next_track() -> void:
	i = (i + 1) % music.size()



func stop_timing() -> void: pass
func start_timing() -> void:
	var paused: bool = stream_paused
	stop()
	_load_music()
	if paused: stream_paused = true

func set_record_playback(record: Variant) -> void:
	if record is Dictionary:
		load_music(record.track)
		seek(record.position)
	else:
		load_music(record)






signal change_danger(finished: bool)

@onready var reorder: Timer = $reorder

var environment: Array[String] = ["ambient", "heating", "rampage"]
var _enemies: int = 0
var _adjust: Vector2i = Vector2.ZERO
var _selection: int = 0
var _previous: int = _selection
var _spawn: bool = false

var previous_state: String:
	get: return environment[_previous]
var state: String:
	get: return environment[_selection]

func ready() -> void: timeout.connect(sync_enemy_music)

func add_enemy(_body) -> void:
	_adjust.x += 1
	reorder.start()
	#match_enemy()

func drop_enemy(_body) -> void:
	_adjust.y += 1
	reorder.start()
	#match_enemy()

func sync_enemy_music() -> void:
	var delta: int = _adjust.x - _adjust.y
	_enemies += delta
	_adjust = Vector2.ZERO
	if delta != 0:
		match_enemy()

func add_spawn(_body) -> void: _spawn = true
func drop_spawn(_body) -> void: _spawn = false

func match_enemy() -> void:
	_previous = _selection
	match _enemies:
		0: _selection = 0
		1, 2:
			if _selection != 2:
				_selection = 1
		_: _selection = 2 if _spawn else 1
	if _selection != _previous:
		change_danger.emit(false)





@onready var detector: Control = $detector

func _ready() -> void:
	#hide()
	# var dialog: FileDialog = FileDialog.new()
	# print("OPTION: ", dialog.get_option_values(0))
	$processor.set_soundtrack(detector.soundtrack)
	SoundtrackSystem.update_ost()

func set_settings_transition(settings: CanvasLayer) -> void:
	detector.soundtrack.options.back.pressed.connect(func():
		hide()
		settings.show()
	)


const prefix: String = " FPS"

func _process(_delta: float) -> void: text = str(Engine.get_frames_per_second(), prefix)

func drawback(asset: Node2D) -> void:
	var fov: VisibleOnScreenNotifier2D = asset.get_node(^"fov")
	fov.screen_entered.connect(asset.show)
	fov.screen_exited.connect(asset.hide)




@onready var ui: Control = get_parent()
@onready var modulator: Node = $modulator

func _ready():
	if ui.has_method("disappear"):
		timeout.connect(ui.disappear)
	else:
		timeout.connect(disappear)

func disappear() -> Tween:
	return modulator.disappear(ui)

func appear() -> void:
	modulator.appear(ui)
	start()


extends Node

const TIME: float = 0.25
const MARGIN: int = 20

var appeared: bool = false
@onready var m: MarginContainer = get_node("../content/margin")

func set_margin(v: int) -> void:
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)

func disappear(ui: Control) -> Tween:
	appeared = false
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_margin, 0, MARGIN, TIME)
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, TIME)
	return tween

func appear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	if not appeared:
		tween.set_parallel(true)
		tween.tween_property(ui, "modulate", Color.WHITE, TIME)
		tween.tween_method(set_margin, MARGIN, 0, TIME)
		appeared = true
	return tween


extends Node

@export_range(0.5, 4.0, 0.5) var time: float = 0.75

func disappear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, time)
	return tween

func appear(ui: Control) -> void:
	ui.modulate = Color.WHITE


class_name ControlTimeHooder extends Timer

const TIME: float = 0.5

@export var fix_on_press: bool = false
@export var target_path: String = ".."

var state: Control
var target: Control
var fixed: bool = false

func _ready() -> void:
	state = get_parent()
	target = get_node(target_path)
	if fix_on_press: state.pressed.connect(set_fixed)
	for s in [state.focus_entered, state.mouse_entered]: s.connect(in_focus)
	for s in [state.focus_exited, state.mouse_exited]: s.connect(out_focus)
	_start_hide()

func _change_state(color: Color) -> void:
	create_tween().tween_property(target, "modulate", color, TIME)

func set_fixed() -> void:
	fixed = !fixed
	if fixed:
		_stop_hide()

func out_focus() -> void: if not fixed: _start_hide()
func in_focus() -> void: _stop_hide()

func _start_hide() -> void:
	start()

func _stop_hide() -> void:
	stop()
	_show_pause()

func _show_pause() -> void: _change_state(Color.WHITE)

func hide_pause() -> void: _change_state(Color.TRANSPARENT)



extends Node

@onready var caption: RichTextLabel = get_parent().get_locale()
@onready var locale: String = caption.text
@export var keys: Array[String] = ["KAL+KAU+KAD+KAR", "KB"]

func merge_controls(help: String) -> String:
	if not help.contains("+"): return tr(help)
	
	var result: String = ""
	for text in help.split("+"): result += tr(text)
	return result

func update_locale() -> void:
	var result: Array[String] = []
	for key in keys: result.append(merge_controls(key))
	caption.text = tr(locale) % result

func _ready() -> void: update_locale()





class_name BinaryChoice extends Button

@onready var status: Label = $status

@export var _caption: Array = _default_caption()

var _choice: bool = false
var selection: String:
	get: return tr(_caption[int(_choice)])

func _default_caption() -> Array: return ["SOFF", "SON"]
func _view() -> Variant: return status

func sync_caption() -> void:
	_view().text = selection

func change_choice(state: bool = !_choice) -> void:
	_choice = state
	sync_caption()


"""
func _default_caption() -> Array: return ["SWND", "SFSN"]

func _view() -> Variant: return self

func _ready() -> void: change_choice(bool(DisplayServer.window_get_mode()))

func set_fullscreen() -> void: DisplayServer.window_set_mode(int(_choice))

func toggle() -> void:
	change_choice()
	set_fullscreen()

"""




#extends Button
#@onready var help: RichTextLabel = $help
#@onready var image: TextureRect = $icon
#var no: int

func _ready() -> void: pressed.connect(flip_the_card)

const TIME: float = 0.2
const MARGIN: String = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

func translate(card: Button) -> void:
	card.text = tr("H" + Def.hints[card.no] + "T") + MARGIN
	card.help.text = tr("H" + Def.hints[card.no] + "D") % [] # Def

func update_hint(card: Button, next: int) -> void:
	card.no = next
	card.image.texture = ImageTexture.create_from_image(Def.help.get_layer_data(card.no))
	translate(card)

func flip_the_card(card: Button) -> void:
	if card.image.visible:
		_change_state(card.image, card.help)
	else:
		_change_state(card.help, card.image)

func change_state(prev: CanvasItem, next: CanvasItem) -> Callable:
	return func(x: float):
		if -0.5 <= x and x <= 0.5 and prev.visible:
			prev.hide()
			next.show()
		self.scale = Vector2(abs(x), 1)

func _change_state(prev: CanvasItem, next: CanvasItem) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(change_state(prev, next), -1.0, 1.0, TIME)
