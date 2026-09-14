class_name WorldInput extends CanvasLayer

enum { LEVEL, LOGIC, BOX = 2, POS = 4, AURA = 6, RESOURCE = 7, STATUS = 8,
	INVENTORY = 10, BESTIARY = 38, NOTES = 39, BOOKS = 40, CHESTS = 41, SECRETS = 42 }
enum { SETTINGS, SAVES, ACHIEVEMENTS, DIFFICULTY = 0, PART, DUNGEON, PROGRESSED, BAG = 7 }

var session: PackedInt64Array

var level: LevelRoot
var adversary: Adversary
var animation: CharacterAnimation
var interact: WorldInteraction
var _inventory: HeroInventory
var menu: Menu = Menu.new()
var entity: Array[PhysicsBody2D] = []

enum { CURRENTS, PLATFORMS, PLACES }
var size: PackedByteArray = [0, 0, 0]

var fire: GPUParticles2D; var rain: GPUParticles2D

func check(type: int) -> int: return session[type]
func unlock(type: int, slot: int) -> void:
	session[type] = Def.to1(session[type], slot)

func get_part(type: int, slot: int) -> int:
	return Def.of_x(Def.BYTE, session[type], slot)

func set_part(type: int, slot: int, value: int) -> void:
	session[type] = Def.to_x(Def.BYTE, session[type], slot, value)

func get_stat(type: int, slot: int) -> int:
	return Def.of_x(Def.SHORT, session[type], slot)
	
func set_stat(type: int, slot: int, value: int) -> void:
	session[type] = Def.to_x(Def.SHORT, session[type], slot, value)

func get_item(bag: int, slot: int) -> int:
	return Def.of_x(Def.SHORT, session[INVENTORY + BAG * bag + (slot >> Def.MASK)], slot & Def.MASK3)

func set_item(bag: int, slot: int, item: int) -> void:
	var no: int = INVENTORY + BAG * bag + (slot >> Def.MASK)
	session[no] = Def.to_x(Def.SHORT, session[no], slot & Def.MASK3, item)

func new_hero(no: int) -> CharacterBody2D:
	if entity[no] == null:
		var hero: CharacterBody2D = load(Def.ray if no == Def.RAY else Def.rock).instantiate()
		hero.name = &"ray" if no == Def.RAY else &"rock"
		hero.no = no
		add_child(hero)
		return hero
	return entity[no]

func load_hero(that: int) -> void:
	if entity[that] == null:
		entity[that] = new_hero(that)

func _ready() -> void:
	layer = 2
	level.load_level()
	load_hero(HUD.hero)
	if level.group:
		entity[HUD.hero].position = level.group.position
		level.group.reparent(entity[HUD.hero])
		level.group.position = Vector2.ZERO


func load_game_logic() -> void:
	if interact != null: return
	interact = WorldInteraction.new()
	animation = CharacterAnimation.new()
	aura = Adversary.new()
	inventory = HeroInventory.new()

func next_hero() -> int: return (HUD.hero + 1) & Def.ROCK

#var session: PackedInt64Array = []
 # model : L1 (SCORE)P2 E4 A2 N4 S8 B4 A2 R2 

func _init() -> void:
	state[BODY] = Def.to0(state[BODY], RUN)
	session = FileAccess.get_file_as_bytes(Def.saves).to_int64_array()

var xp: RefCounted
@onready var tree: SceneTree = get_tree()

func load_scene(no: int) -> void:
	var scene: String
	&"dungeon/cave/dark"
	Def.level % [location.name, group_level(), location.part]
	&"res://def/dungeon/%s/%s/%d.tscn"
	var _level: int = level + diff
	
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	path % abs(_level)
	
	print_debug(tree.change_scene_to_file(scene))

#var options: VBoxContainer = get_node("../hud/back/options")
#options.continue.pressed.connect()
#options.start.pressed.connect(game_start)

func game_exit() -> void: tree.quit()
func game_start() -> void: load_scene(Def.first_level)
func game_continue() -> void: if not load_progress(): load_scene(Def.first_level)




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





# @onready var game: Control = $game
# var pause: Control
# func set_pause() -> void:
# 	pause = load(LoadBus.hud % "pause").instantiate()

@onready var right: HSplitContainer = $right
@onready var left: HSplitContainer = right.get_node(^"left")
@onready var top: VSplitContainer = left.get_node(^"top")
@onready var bottom: VSplitContainer = top.get_node(^"bottom")

@onready var controls: MarginContainer = bottom.get_node(^"controls")
@onready var log: TextureRect = controls.get_node(^"controls/log")
@onready var log_text: RichTextLabel = controls.get_node(^"controls/log/text")
@onready var talk_image: RichTextLabel = controls.get_node(^"dialog/talk/image")

@onready var right_priorities: PanelContainer = right.get_node(^"priorities")
@onready var left_stats: PanelContainer = left.get_node(^"stats")
@onready var top_inventory: PanelContainer = top.get_node(^"inventory") # PanelContainer
@onready var bottom_ability: PanelContainer = bottom.get_node(^"ability")

## UI STATS
var _stat_bar: PackedScene = null
var _stats_scroll: ScrollContainer; var stats_scroll: ScrollContainer:
	get: return _lazy(left_stats, &"_stats_scroll", &"res://def/hud/game/stats.tscn")
var _stats_description: ScrollContainer; var stats_description: ScrollContainer:
	get: return _from(stats_scroll, &"_stats_description", ^"description")
var _stats_chats: ScrollContainer; var stats_chats: ScrollContainer:
	get: return _from(stats_scroll, &"_stats_chats", ^"stats_chats")
var _power_stat: Button; var power_stat: Button:
	get: return _from(stats_scroll, &"_power_stat", ^"margin/stack/power")
var _power_base: ProgressBar; var power_base: ProgressBar:
	get: return _from(power_stat, &"_power_base", ^"base")
var _power_next: ProgressBar; var power_next: ProgressBar:
	get: return _lazy(power_stat, &"_power_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _influence_stat: Button; var influence_stat: Button:
	get: return _from(_stats_scroll, &"_influence_stat", ^"margin/stack/influence")
var _influence_base: ProgressBar; var influence_base: ProgressBar:
	get: return _from(influence_stat, &"_influence_base", ^"base")
var _influence_next: ProgressBar; var influence_next: ProgressBar:
	get: return _lazy(influence_stat, &"_influence_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _vitality_stat: Button; var vitality_stat: Button:
	get: return _from(stats_scroll, &"_vitality_stat", ^"margin/stack/vitality")
var _vitality_base: ProgressBar; var vitality_base: ProgressBar:
	get: return _from(vitality_stat, &"_vitality_base", ^"base")
var _vitality_next: ProgressBar; var vitality_next: ProgressBar:
	get: return _lazy(vitality_stat, &"_vitality_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _reaction_stat: Button; var reaction_stat: Button:
	get: return _from(stats_scroll, &"_reaction_stat", ^"margin/stack/reaction")
var _reaction_base: ProgressBar; var reaction_base: ProgressBar:
	get: return _from(reaction_stat, &"_reaction_base", ^"base")
var _reaction_next: ProgressBar; var reaction_next: ProgressBar:
	get: return _lazy(reaction_stat, &"_reaction_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")

var _priorities_scroll: ScrollContainer; var priorities_scroll: ScrollContainer:
	get: return _lazy(right_priorities, &"_priorities_scroll", &"res://def/hud/game/priorities.tscn")
var _priority_progress: ProgressBar; var priority_progress: ProgressBar:
	get: return _from(priorities_scroll, &"_priority_progress", ^"stack/priority/progress")
var _perks: ItemList; var perks: ItemList:
	get: return _from(priorities_scroll, &"_perks", ^"stack/perks")
var _pages: ItemList; var pages: ItemList:
	get: return _from(priorities_scroll, &"_pages", ^"stack/pages")
var _books: VBoxContainer; var books: VBoxContainer:
	get: return _from(priorities_scroll, &"_books", ^"stack/books")
var _pursuit: Button; var pursuit: Button:
	get: return _from(priorities_scroll, &"_pursuit", ^"stack/priority/pursuit")
var _self_control: Button; var self_control: Button:
	get: return _from(priorities_scroll, &"_self_control", ^"stack/priority/self_control")
var _tenacity: Button; var tenacity: Button:
	get: return _from(priorities_scroll, &"_tenacity", ^"stack/priority/tenacity")

var _ability_scroll: ScrollContainer; var ability_scroll: ScrollContainer:
	get: return _lazy(right_ability, &"_ability_scroll", &"res://def/hud/game/ability.tscn")
var _ability_skills: ItemList; var ability_skills: ItemList:
	get: return _from(ability_scroll, &"_ability_skills", ^"stack/skills")
var _ability_title: ProgressBar; var ability_title: ProgressBar:
	get: return _from(ability_scroll, &"_ability_title", ^"stack/title")
var _ability_effect: ProgressBar; var ability_effect: ProgressBar:
	get: return _from(ability_scroll, &"_ability_effect", ^"stack/effect")
var _ability_help: ProgressBar; var ability_help: ProgressBar:
	get: return _from(ability_scroll, &"_ability_help", ^"stack/help")
var _ability_research: Button; var ability_research: Button:
	get: return _from(ability_scroll, &"_ability_research", ^"stack/status/research")
var _ability_health: Button; var ability_health: Button:
	get: return _from(ability_scroll, &"_ability_health", ^"stack/status/health")
var _ability_health_bar: ProgressBar; var ability_health_bar: ProgressBar:
	get: return _from(ability_scroll, &"_ability_health_bar", ^"stack/status/health/bar")
var _ability_score: Label; var ability_score: Label:
	get: return _from(ability_scroll, &"_ability_score", ^"stack/status/score")
var _ability_meter: Label; var ability_meter: Label:
	get: return _from(ability_scroll, &"_ability_meter", ^"stack/status/score/meter")
var _ability_pallete: ItemList; var ability_pallete: ItemList:
	get: return _from(ability_scroll, &"_ability_pallete", ^"stack/pallete")
var _ability_pallete_hint: Label; var ability_pallete_hint: Label:
	get: return _from(ability_scroll, &"_ability_pallete_hint", ^"stack/pallete_hint")

var _inventory_scroll: ScrollContainer; var inventory_scroll: ScrollContainer:
	get: return _lazy(top_inventory, &"_inventory_scroll", &"res://def/hud/game/inventory.tscn")
var _inventory_bestiary: HFlowContainer; var inventory_bestiary: HFlowContainer:
	get: return _from(inventory_scroll, &"_inventory_bestiary", ^"stack/bestiary")
var _bestiary_number: Label; var bestiary_number: Label:
	get: return _from(inventory_bestiary, &"_bestiary_number", ^"number")
var _bestiary_effect: Label; var bestiary_effect: Label:
	get: return _from(inventory_bestiary, &"_bestiary_effect", ^"effect")
var _inventory_status: GridContainer; var inventory_status: GridContainer:
	get: return _from(inventory_scroll, &"_inventory_status", ^"stack/bag/status")

var _side_equip: bool = false
var _main_items: Array[Button] = []
var _side_items: Array[Button] = []

var inventory_select: TextureRect = preload("res://def/hud/game/inventory_select.tscn").instantiate()

var _main_inventory: GridContainer; var main_inventory: GridContainer:
	get: return _from(inventory_scroll, &"_main_inventory", ^"stack/main_inventory")
var _side_inventory: GridContainer; var side_inventory: GridContainer:
	get:
		if _side_inventory == null: _side_inventory = load(Def.items).instantiate()
		return _side_inventory

var _inventory_scroll: ScrollContainer; var inventory_scroll: ScrollContainer:
	get: return _lazy(top_inventory, &"_inventory_scroll", &"res://def/hud/game/inventory.tscn")


var inventory_items: Array

@onready var help: VBoxContainer = controls.get_node(^"middle/help")

func _lazy(parent: Control, name: StringName, path: StringName, cache: StringName = &"") -> void:
	var node: Control = get(name); if node != null: return node
	if cache != &"":
		var cached: PackedScene = get(cache)
		if cached == null:
			cached = load(path)
			set(cache, cached)
		node = cached.instantiate()
	else:
		node = load(path).instantiate()
	parent.add_child(node)
	set(name, node)
	return node

func _from(parent: Control, name: StringName, path: NodePath) -> Control:
	var node: Control = get(name); if node != null: return node
	node = parent.get_node(path); set(name, node); return node
"""
func _ready():
	get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()
"""

func _on_viewport_resize():
	var ui: Window = get_window()
	var margins: Vector2 = Vector2(ui.size.x * 0.01, ui.size.y * 0.01)
	set("theme_override_constants/margin_left", margins.x)
	set("theme_override_constants/margin_right", margins.x)
	set("theme_override_constants/margin_top", margins.y)
	set("theme_override_constants/margin_bottom", margins.y)
	# Starts the timer or resets its time_left if already running.

func _on_view_port_resize_timer_timeout():
	print("viewport size has stabilized - do performance-heavy stuff")







extends VSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.y * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)

func open_menu(next: int) -> void:
	split_offset = next
	on_drag_end()


extends VSplitContainer

var stack: String = "ability/controls/markers/margin/stack/"

@export var reserve: Array[PackedFloat32Array] = [[-6, -0.5], [-70, -0.5], [-106, -0.5]]
@export var node_paths: Array[Array] = [["../topic/scroll/margin/stack/selection"],
	[stack + "ray", stack + "rock"], [stack + "rock"]]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []
var direction: float:
	get: return reserve[0][1]
var proportion: float:
	get: return get_proportion(direction)

func get_proportion(dir: float) -> float:
	return get_window().size.y * dir

func _ready() -> void:
	for i in range(0, len(node_paths)):
		ui_nodes.append([])
		for path in node_paths[i]:
			ui_nodes[i].append(get_node(path))

func on_drag_end() -> void:
	for i in range(0, len(reserve)):
		var dir: float = reserve[i][1]
		var next: float = float(reserve[i][0] + split_offset)
		logic.drag_feedback(dir, get_proportion(dir), next, ui_nodes[i])



extends HSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.x * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)





extends Node

@export var controls: SplitNavigation
@export_range(Vector2.Axis.AXIS_X, Vector2.Axis.AXIS_Y, 1) var axis: int

@export_group("Offset")
@export var direction: float = -0.5
@export var reserve: Array = [-6]

@export_group("Paths")
@export var node_paths: Array[Array] = [[""]]
@export var focus_paths: Array[String] = ["", ""]

@onready var input: Node = $input
@onready var focus: Node = $focus
@onready var hud: Node = $hud
@onready var ui: SplitContainer#  = get_parent()

var proportion: float:
	get: return get_window().size[axis] * direction

func face(ax: int, dir: float, res: Array, focused: Control, nodes: Array) -> void:
	axis = ax; direction = dir; reserve = res
	setup(nodes, focused)

func get_nodes(paths: Array) -> Array:
	var nodes: Array = []
	for path in paths: nodes.append(get_node(path))
	return nodes

func setup(nodes: Array, focused: Control) -> void:
	hud.setup(self, nodes)
	focus.setup(self, focused)
	input.set_order()
# func _ready() -> void: setup()





extends Node

var mask: Array[int]
var actions: Array[Node]

func sort_descending(a, b): return a[1] > b[1]

func set_mask_weight(weight: Dictionary) -> Array:
	var masked: Array = []
	for i in range(0, len(actions)):
		var j: int = actions[i].actions.max_button_count
		if weight.has(j):
			weight[j].append(i)
		else:
			weight[j] = []
			masked.append([i, j])
	return masked

func set_order() -> void:
	var weight: Dictionary = {}
	var masked: Array = set_mask_weight(weight)
	masked.sort_custom(sort_descending)
	
	mask = []
	for entry in masked:
		mask.append(entry[0])
		for next in weight[entry[1]]:
			mask.append(next)

func _input(event: InputEvent) -> void:
	for i in mask:
		if actions[i].listen(): # event
			break




extends Node

enum { LOGIC = 0, HOTKEY = 1 }

#func restart_focus(actions: Array[Node]) -> void:
	#for i in range(0, 2): actions[i].restart_delay()

func get_controls_focus(l: SplitToggleLogic, controls: SplitNavigation) -> Array:
	return [[l.focus_straight, controls.panel_focus], [l.focus_backward, controls.tab_focus],
		[l.straight_drag, controls.smooth_direct], [l.backward_drag, controls.smooth_back],
		[l.instant_drag, controls.instant]]

func setup(navigation: Node, focused: Control) -> void:
	navigation.hud.logic.focus = focused# navigation.get_nodes(navigation.focus_paths)
	
	var actions: Array[Node] = get_children()
	var logic: Array = get_controls_focus(navigation.hud.logic, navigation.controls)
	
	for i in range(0, len(logic)):
		actions[i].actions = logic[i][HOTKEY]
		actions[i].feedback.connect(func(): logic[i][LOGIC].call())
	# for i in range(2, 5):
		# actions[i].feedback.connect(func(): restart_focus(actions))
	
	navigation.input.actions = actions




class_name ActionsManager extends RefCounted

var switch: ActionsSwitch = ActionsSwitch.new()

func build_caption(action: String, act: int) -> String:
	return action if act == 0 else str(action, "_", act)

func listen_events(acts: ActionButtonGroup, action: String, impulsed: bool, fixed: bool) -> void:
	switch.reset_time(true)
	switch.reset_power()
	var key: String
	for act in acts.group:
		key = build_caption(action, act.id)
		match act.state:
			ActionButton.STATE.TOGGLED: switch.touch(Input.is_action_just_pressed(key))
			ActionButton.STATE.RELEASED: switch.touch(Input.is_action_just_released(key))
			ActionButton.STATE.PRESSED: switch.touch(Input.is_action_pressed(key))
	if switch.timed: switch.set_power(fixed or impulsed, key)

func listen_groups(actions: ActionButtonComplex, fixed: bool) -> void:
	switch.reset_time(false)
	var i: int = len(actions.complex)
	while (not switch.timed) and (i > 0):
		i -= 1
		listen_events(actions.complex[i], actions.action, not actions.power, fixed)

func listen(actions: ActionButtonComplex, fixed: bool) -> bool:
	listen_groups(actions, fixed)
	switch.give_feedback(fixed)
	return switch.timed

func power(actions: ActionButtonComplex, fixed: bool) -> float:
	listen(actions, fixed)
	return switch.power

func get_axis(left: ActionButtonComplex, right: ActionButtonComplex, fixed: bool) -> float:
	return power(right, fixed) - power(left, fixed)

func get_vector(left: ActionButtonComplex, right: ActionButtonComplex,
	forward: ActionButtonComplex, backward: ActionButtonComplex, fixed: bool) -> Vector2:
	return Vector2(get_axis(left, right, fixed), get_axis(forward, backward, fixed))




extends Node

signal resume_input()
signal suspend_input()

@onready var timer: Timer = $suspend

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []

func _ready() -> void:
	timer.timeout.connect(drag_feedback)

func setup(navigation: Node, nodes_pack: Array) -> void:
	logic.navigation = navigation
	logic.navigation.ui.drag_ended.connect(on_drag_end)
	logic.navigation.ui.drag_started.connect(on_drag_start)
	for nodes in nodes_pack: # navigation.node_paths:
		ui_nodes.append(nodes)#navigation.get_nodes(paths))

func on_drag_start() -> void:
	print("SUSPEND INPUT")
	suspend_input.emit()

func drag_feedback() -> void:
	print("RESUME INPUT")
	resume_input.emit()

func delay_feedback() -> void:
	timer.start()
	on_drag_start()

func on_drag_end() -> void:
	for i in range(0, len(logic.navigation.reserve)):
		logic.drag_feedback(logic.is_opened_at(i), ui_nodes[i])
	#if not logic.is_opened_last:
	drag_feedback()




extends RefCounted

class_name SplitToggleLogic

var toggled: bool = false
var focus: Control
var navigation: Node
var is_opened_last: bool:
	get: return is_opened_at(-1)
var is_opened_first: bool:
	get: return is_opened_at(0)

enum { STRAIGHT = 0, BACKWARD = 1, MOVE = 3 }

func hide(nodes: Array) -> void: toggle(nodes, "hide")
func show(nodes: Array) -> void: toggle(nodes, "show")
func toggle(nodes: Array, prop: String) -> void:
	for node in nodes:
		var next: String = prop + "s"
		node.get(next if next in node else prop).call()

func open_condition(direction: float) -> Callable:
	return (func(a, b): return a > b) if direction < 0 else (func(a, b): return a < b)

func is_opened_at(item: int) -> bool:
	var n: Node = navigation
	var offset: float = float(n.reserve[item] + n.ui.split_offset)
	# print("OFFSET: ", offset, (" >" if n.direction < 0 else " <"), " PORTION: ", n.proportion)
	return open_condition(n.direction).call(offset, n.proportion)

func drag_feedback(opened: bool, nodes: Array) -> void:
	if opened: hide(nodes)
	else: show(nodes)

func open_menu(next: int) -> void:
	navigation.ui.split_offset = next
	navigation.hud.on_drag_end()

func _get_move(a: int, b: int, dir: float) -> float:
	return MOVE * (a if dir < 0 else b)

func out_screen_drag(condition: bool, offset: float, portion: float) -> void:
	open_menu(int(portion if condition else offset))

func straight_drag() -> void:
	var move: float = _get_move(1, -1, navigation.direction)
	var offset: float = navigation.ui.split_offset + move
	var portion: float = navigation.proportion
	out_screen_drag(offset > portion if move < 0 else offset < portion, offset, portion)
	navigation.hud.delay_feedback()

func backward_drag() -> void:
	var move: float = _get_move(-1, 1, navigation.direction)
	open_menu(navigation.ui.split_offset + move)
	navigation.hud.delay_feedback()

func set_effect(offset: int, focused: int) -> void:
	open_menu(offset)
	_set_focus(focused)

func instant_drag() -> void:
	toggled = !toggled
	if toggled: set_effect(0, STRAIGHT)
	else: set_effect(navigation.proportion, BACKWARD)

func _set_focus(no: int) -> void:
	match no:
		0: focus.grab_focus()

func focus_backward() -> void:
	if not is_opened_first: _set_focus(BACKWARD)

func focus_straight() -> void:
	if is_opened_last: _set_focus(STRAIGHT)




extends HSplitContainer

@onready var stats: HSplitContainer = $stats



@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation
# @onready var points: Array[Button] = _get_points()

# func _ready() -> void: drag_started.connect(topic.update_stack)

func _get_points() -> Array[Button]:
	var items: MarginContainer = stats.inventory.topic.stack.status
	var file: MarginContainer = topic.stack.status
	return [
		items.get(&"ray").get(&"health"), file.get(&"ray").get(&"health"),
		items.get(&"ray").get(&"ability"), file.get(&"ray").get(&"ability"),
		items.get(&"rock").get(&"health"), file.get(&"rock").get(&"health"),
		items.get(&"rock").get(&"ability"), file.get(&"rock").get(&"ability"),
	]


extends VBoxContainer

@onready var heroes: Array[HFlowContainer] = [$ray, $rock]
@onready var bank: VBoxContainer = $bank

func connect_opened(opened: Button, ability: VBoxContainer) -> void:
	if opened:
		opened.focus_entered.connect(func(): ability.show())
		opened.focus_exited.connect(func(): ability.hide())
		opened.mouse_entered.connect(func(): ability.show())
		opened.mouse_exited.connect(func(): ability.hide())

func connect_ability(ability: BoxContainer) -> void:
	for hero in heroes:
		var path: NodePath = NodePath(ability.name)
		if hero.has_node(path):
			connect_opened(hero.get_node(path), ability) #  + "/opened"

func connect_category(category: VBoxContainer) -> void:
	for ability in category.get_children():
		connect_ability(ability)
"""
func _ready() -> void:
	for category in bank.get_children():
		connect_category(category)
"""


extends Label

@onready var tabs: HBoxContainer = get_parent()

func transparent() -> void: tabs.modulate = Color.TRANSPARENT
func usual() -> void: tabs.modulate = Color.WHITE

func _ready() -> void:
	mouse_entered.connect(transparent)
	mouse_exited.connect(usual)



extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get:
		update_scroll()
		return _scroll

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get:
		if _stack == null: _stack = scroll.get_node("space/scroll/margin/stack")
		return _stack

func update_stack() -> void:
	if _stack == null:
		_stack = scroll.get_node("space/scroll/margin/stack")
		loaded.emit(_stack)

func update_scroll() -> void:
	if _scroll == null:
		_scroll = load(Def.priorities).instantiate()
		add_child(_scroll)



extends HBoxContainer

@onready var status: VBoxContainer = $status
@onready var synergy: ProgressBar = $synergy/points


extends VBoxContainer
"""
@onready var status: VBoxContainer = $status
@onready var card: MarginContainer = $card
@onready var record: VBoxContainer = $record
@onready var research: VBoxContainer = $research
"""



extends Control

var texts: PackedStringArray = ["Стремление", "⚖️Выдержка", "🪨Упорство"]


extends Label

var description: Array[String] = ["PR", "CM", "PE"]

func connect_priority(p: Button, record: VBoxContainer, method: String) -> void:
	# var selection: VBoxContainer = record.ranking.priority.selection
	var heroes: HBoxContainer = record.ranking.priority.growth.heroes
	var c: Array = [["nter", func(): # priority[record.selected].hide() # priority[p.priority_no].show()
		text = "P%sD" % description[p.priority_no]
		heroes.leader.stats.toggle(p.priority_no, "show")
	], ["xit", func():
		heroes.leader.stats.set_priority(p.priority_no)
		heroes.leader.priority.priorities[record.selected].show()
	]]
	for s in c: p.get("%s_e%sed" % [method, s[0]]).connect(s[1])

func connect_priorities(record: VBoxContainer) -> void:
	for p in record.priorities:
		for method in ["focus", "mouse"]:
			connect_priority(p, record, method)


extends Label

@onready var rank: Label = $rank
@onready var title: Label = $title

var status: VBoxContainer

func calculate_rank() -> void:
	pass # implement based on enemy and hero stats


extends HBoxContainer


extends Label

var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void: text = priorities[no]


extends TextureRect

@onready var priority: VBoxContainer = $back/priority
@onready var stats: VBoxContainer = $back/stats

func change(prev: int, at: int) -> void:
	priority.priorities[prev].hide()
	# priority.priorities[at].show()



@onready var rank: Label = $rank
@onready var value: Label = $value

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

var selected: String = "ray"
var leader: TextureRect:
	get: return get(selected)

func select_hero(party: HeroParty) -> void:
	selected = party.leader.name
	get(selected).show()
	get(party.follower.name).hide()



extends VBoxContainer
"""
#@onready var priority: VBoxContainer = $priority
#@onready var description: Label = $description 

@onready var growth: HBoxContainer = $growth

@onready var pursuit: Button = $pursuit
@onready var self_control: Button = $self_control
@onready var tenacity: Button = $tenacity
@onready var select: MakeStats.PRIORITIES = pursuit.priority_no

var priorities: Array[Button]:
	get: return [pursuit, self_control, tenacity]

func _toggle_call(i: Array[int], ui: VBoxContainer) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: ui.toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button, ui: VBoxContainer) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.priority_no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1], ui))

func connect_priorities(ranking: VBoxContainer) -> void:
	for ui in [ranking.priority.growth, ranking.description]:
		for priority in [pursuit, self_control, tenacity]:
			connect_priority(priority, ui)

@onready var ranking: HFlowContainer = $ranking
@onready var priorities: Array[Button] = ranking.priority.selection.priorities

var selected: int = 0

func _ready() -> void:
	ranking.description.connect_priorities(self)

func connect_priority_select(level: Node, group: Node2D) -> void:
	for button in priorities:
		button.connect_selection(self, level.summary, group.deploy)
	
	group.deploy.select_hero.connect(func(_l):
		ranking.priority.growth.heroes.select_hero(group.deploy.party)
		var hero: String = group.deploy.party.leader.name
		for priority in priorities:
			if priority.priority_no == level.summary.hero[hero].at:
				priority.select()
			else:
				priority.unselect()
			priority.set_hero_priority(priority.priority_no, level.summary, hero)
	)

func set_priorities(level: Node, _stats: Dictionary, group: Node2D) -> void:
	for i in range(0, len(priorities)):
		var hero: String = group.deploy.party.leader.name
		priorities[i].set_hero_priority(i, level.summary, hero)
	# _show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)

"""


@onready var pursuit: Button = $pursuit
@onready var self_control: Button = $self_control
@onready var tenacity: Button = $tenacity
@onready var select: MakeStats.PRIORITIES = pursuit.priority_no

var priorities: Array[Button]:
	get: return [pursuit, self_control, tenacity]

func _toggle_call(i: Array[int], ui: VBoxContainer) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: ui.toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button, ui: VBoxContainer) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.priority_no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1], ui))

func connect_priorities(ranking: VBoxContainer) -> void:
	for ui in [ranking.priority.growth, ranking.description]:
		for priority in [pursuit, self_control, tenacity]:
			connect_priority(priority, ui)



extends Button
"""
@onready var margin: MarginContainer = $margin
@onready var xp: ProgressBar = margin.get_node("level/progress")
@onready var next: Label = $description/next
@onready var caption: Dictionary = {
	"selected": $description/caption/selected,
	"unselected": $description/caption/unselected
}

var priority_no: MakeStats.PRIORITIES = MakeStats.PRIORITIES.get(name)
var selected: Control
var count: Dictionary = {}
var main: String = "ray"

func _ready() -> void:
	var number: HBoxContainer = $description/number
	for hero in ["ray", "rock"]:
		count[hero] = [number.get_node(hero + "/normal"),
			number.get_node(hero + "/selected")]

func _toggle_caption(state: bool) -> void:
	caption.selected.visible = state
	caption.unselected.visible = !state
	for hero in ["ray", "rock"]:
		count[hero][0].visible = !state
		count[hero][1].visible = state
	margin.visible = state
	next.visible = state

func connect_selection(ui: VBoxContainer, summary: Dictionary, deploy: HeroDeploy) -> void:
	pressed.connect(func():
		var hero: String = deploy.party.leader.name
		var prev: int = summary.hero[hero].at
		if summary.hero[hero].of[prev] == PlayerXP.MAX_LV: return
		# ui.selected = ui.addons[name]
		for priority in ui.priorities: priority.unselect()
		ui.ranking.priority.growth.heroes.get(hero).change(prev, priority_no)
		ui.selected = priority_no
		summary.hero[hero].at = priority_no
		set_hero_priority(priority_no, summary, hero)
		select()
	)

func unselect() -> void: _toggle_caption(false)
func select() -> void: _toggle_caption(true)

func set_priority_level(no: int, summary: Dictionary, hero: String) -> void:
	for levels in count[main]:
		var lv: int = summary.hero[hero].of[no]
		levels.text = str(lv)

func set_next_level(no: int, summary: Dictionary, hero: String) -> void:
	next.text = str(summary.hero[hero].of[no] + 1)
	if summary.hero[hero].of[no] == PlayerXP.MAX_LV: next.hide()

func set_hero_priority(no: int, summary: Dictionary, hero: String) -> void:
	set_priority_level(no, summary, hero)
	set_next_level(no, summary, hero)

func set_priority(no: int, summary: Dictionary) -> void:
	for hero in count: set_priority_level(no, summary, hero)
	set_next_level(no, summary, main)

func update_exp(value: int, maximum: int) -> void:
	xp.value = value
	xp.max_value = maximum
"""


extends Label

@onready var number: Label = $number

var addon: Array[Array] = [[0, 1], [1, 3], [2, 3]]
var icons: Array[String] = ["⚔️", "🔥", "🛡", "🫧"]
var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void:
	text = priorities[no] ; hide_number()

func hides() -> void: text = '' ; hide_number()
func hide_number() -> void: number.text = ''

func toggle(no: int, _method: String) -> void:
	text = "%s\r\n%s" % [addon[no].front(), addon[no].back()]
	# number.text += (method)


extends HBoxContainer

@onready var ray: HBoxContainer = $ray



extends HSplitContainer

@onready var inventory: VSplitContainer = $inventory
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

# func _ready() -> void: drag_started.connect(topic.update_stack)



extends Button

@export var image: String = ""

@onready var equipment: ProgressBar = $equipment
@onready var base: ProgressBar = $equipment/base
@onready var number: Label = $number
@onready var icons: Label = $number/icon
@onready var BASE_MAX: int = int(base.max_value)

var equipped: bool = false
var stats_text: String
var equipments: int = 0

func _ready() -> void:
	icons.text = image
	stats_text = text

func set_base(stat: int) -> void:
	_set_base_value(stat)

func add_equip(add: int) -> void:
	var value: int = int(base.value)
	_set_equipment_value(value + add)

func _set_equipment_value(value: int) -> void:
	equipments = value
	if equipped: equipment.value = value

func _set_base_value(value: int) -> void:
	base.value = value
	number.text = str(value)
	text = stats_text
	if not equipped:
		text += " (%d)" % equipments

func _set_view_values(based: int, equip: int) -> void:
	equipment.value = equip
	base.max_value = based

func set_view_type(mode: bool) -> void:
	equipped = mode
	if equipped:
		_set_view_values(int(equipment.max_value), 0)
	else:
		_set_view_values(BASE_MAX, equipments)
	_set_base_value(int(base.value))



extends VBoxContainer

@onready var stats: Array[Button] = [$power, $influence, $vitality, $reaction]

func set_stats(values: Array) -> void:
	for i in range(0, len(stats)):
		stats[i].set_base(values[i])


extends HBoxContainer

@onready var ray: Control = $ray
@onready var rock: Control = $rock

func select_hero(party: HeroParty) -> void:
	var leader: Control = get(party.leader.name)
	var follower: Control = get(party.follower.name)
	
	leader.back.hide()
	follower.back.show()
	remove_child(follower)
	add_child(follower)




extends TextureRect#Button

signal switch_bags(bag: String)

@onready var back: PanelContainer = $back

var inventory: Node

# func _ready() -> void: pressed.connect(switch)

func set_inventory(group: Node2D) -> void:
	inventory = group.get(name).to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: trade(cell)

func trade(cell: Control) -> void:
	var slot: int = inventory.logic.find_empty_slot()
	if slot != inventory.logic.items.ui.NONE:
		cell.image.holder = null
		cell.inventory.logic.trade_bags(inventory.logic, cell.slot, slot)

func switch() -> void: switch_bags.emit(name)



extends Label

var stats: Dictionary = {
	"power": "SPWD", "influence": "SNFD",
	"vitality": "SVTD", "reaction": "SRCD"
}

func sets(stat: String) -> void:
	text = tr(stats[stat])


extends MarginContainer

@onready var bag: HBoxContainer = $value/bag
@onready var description: Label = $description
@onready var heroes: Array = [$value/heroes/ray, $value/heroes/rock] #@onready var heroes: HBoxContainer = $heroes
var main: VBoxContainer:
	get: return heroes[0] # @onready var description: VBoxContainer = $description

func set_stats(summary: Dictionary, hero: String) -> void:
	main.set_stats(summary.stats[hero]) # var summary: Dictionary = level.summary

func connect_description(opened: Button) -> void:
	opened.focus_entered.connect(func(): description.sets(opened.name)) # opened.focus_exited.connect(func(): caption.hide())
	opened.mouse_entered.connect(func(): description.sets(opened.name)) # opened.mouse_exited.connect(func(): caption.hide())

#func _ready() -> void:
#	for caption in main.stats: connect_description(caption) # for caption in description.get_children():



extends HBoxContainer

@onready var equip: Button = $equip
@onready var state: Control = $state



extends VBoxContainer

"""
var chat: VBoxContainer

@onready var logs: PanelContainer = $log
@onready var items: PanelContainer = $notes
@onready var notes: PanelContainer = $notes
@onready var title: VBoxContainer = $title
@onready var card: MarginContainer = $card
"""




extends VBoxContainer

@onready var bag: HFlowContainer = $bag
@onready var stats: VBoxContainer = $stats
@onready var chats: VBoxContainer = $chats

func connect_bag(ui: Array, inventory: HFlowContainer, opened: Node) -> void:
	for change in ui:
		for b in [bag, inventory]:
			change.switch_bags.connect(b.switch)
		change.switch_bags.connect(func(h):
			opened.bag = h
			opened.other = !opened.other)

func toggle_buttons(stack: VBoxContainer, status: VBoxContainer, leader: String, opened: Node, feedback: Callable) -> Array:
	var b: Button = stack.status.get(leader).bag
	var b2: Button = status.get(leader).bag
	var ui: TextureButton = stats.stats.bag.get(leader)
	var res: Array = [ui, b, b2]
	for i in res: feedback.call(i)
	return res

func _toggle_order(stack: VBoxContainer, status: VBoxContainer, party: HeroParty, opened: Node) -> void:
	for i in [[party.leader.name, func(i): i.disabled = true], [party.follower.name, func(i): i.disabled = false]]:
		toggle_buttons(stack, status, i[0], opened, i[1])

func connect_group(stack: VBoxContainer, status: VBoxContainer, group: Node2D, opened: Node) -> void:
	stack.connect_group(group)
	for hero in ["ray", "rock"]:
		for bg in [bag, stack.bag]: bg.connect_group(hero, group, opened)
		var res = toggle_buttons(stack, status, hero, opened, func(i): i.set_inventory(group))
		connect_bag(res, stack.bag, opened)
	group.deploy.select_hero.connect(func(_h):
		bag.select_hero(group)
		stack.bag.select_hero(group)
		opened.bag = group.deploy.party.follower.name
		
		_toggle_order(stack, status, group.deploy.party, opened)
	)
	_toggle_order(stack, status, group.deploy.party, opened)



extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get: return update_scroll()

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get: return update_stack()

func update_stack() -> VBoxContainer:
	if _stack == null:
		_stack = scroll.get_node("control/scroll/margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null # Works.upload(self, _scroll, Def.game % "stats", "stats")





extends HBoxContainer

@onready var pause: Button = $pause
@onready var menu: Button = $menu
@onready var icons: Button = $icons


extends Button

@onready var margin: MarginContainer = $margin



extends MarginContainer

@onready var icon: TextureRect = $icon



extends Label

const DELAY: int = 2

@onready var timer: Timer = $timer
@onready var count: TextureRect = $count
@onready var multiplier: Label = $multiplier

#@onready var score: HBoxContainer = $score
#@onready var options: Control = $options
@onready var meter: ProgressBar = $meter

func set_fixed(state: bool) -> void:
	fixed = state
	# meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func update_meter(time: float, maximum: float) -> void:
	multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	multiplier.finish()
	meter.finish()

func set_hide_xp() -> void:
	pass

var fixed: bool = false

func set_show_xp(group_xp: Node) -> void:
	meter.new_score(group_xp)
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = base_xp + value.x
			if not fixed: timer.appear()
			# score.show()
			)

var record: int
var no: int:
	set(next):
		if not is_new_level:
			text = str(next)
		else:
			record = next
var is_new_level: bool = false
var first_entry: bool = true

func set_effect() -> void:
	create_tween().tween_method(func(w: Color):
		self_modulate = w
		if w == Color.TRANSPARENT:
			is_new_level = false
			text = str(record)
		, Color.WHITE, Color.TRANSPARENT, DELAY).set_delay(DELAY)

func new_level_up(_level: Node, _stats: Dictionary) -> void:
	if is_new_level: return # if level.summary.xp == 0: return
	if first_entry: first_entry = false ; return
	is_new_level = true
	record = int(text)
	text = tr("RECD")
	set_effect()

"""
func _ready() -> void:
	level_up.mouse_entered.connect(value.show) # next
	level_up.mouse_exited.connect(value.hide) # next
"""



extends Control

@onready var timer: Timer = $timer
@onready var count: TextureRect = $count
@onready var multiplier: Label = $multiplier

var fixed: bool = false

func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = base_xp + value.x
			if not fixed: timer.appear()
			# score.show()
			)




extends Label

@onready var modulator: Node = $modulator

func finish() -> void: modulator.disappear(self)

func multiply(x: String) -> String:
	return x.substr(0, x.rfind("0")) + "x" if x[-2] == "0" else x

func update_x(score: float) -> void:
	show()
	text = multiply("%.2fx" % score)

func update_meter(time: float, maximum: float) -> void:
	var portion: float = time / maximum
	material.set("shader_parameter/dissolve_value", portion)
	modulator.appear(self)



extends Control

@onready var score: HBoxContainer = $score
@onready var options: Control = $options
@onready var multiplier: Control = $multiplier

@onready var meter: ProgressBar = $meter
@onready var timer: Timer = $timer

func set_fixed(state: bool) -> void:
	score.fixed = state
	# meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func set_show_xp(group_xp: Node) -> void:
	score.set_show_xp(group_xp)
	# group_xp.update_exp.connect(func(_v, _b): timer.start())
	meter.new_score(group_xp)

func update_meter(time: float, maximum: float) -> void:
	score.multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	score.multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(score.count.new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	score.multiplier.finish()
	meter.finish()

func set_hide_xp() -> void:
	pass
	#timer.timeout.connect(func():
		#pass)
		# space.score.hide()
		# space.multiplier.hide())
"""
func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			space.score.count.text = str(base_xp + value.x)
			space.score.show()
			timer.start())
"""




extends ProgressBar

@onready var fill: StyleBoxFlat = get(KEY)
@onready var timer: Timer = $timer

var fixed: bool = false

const KEY: String = "theme_override_styles/fill"
const COLOR: Dictionary = { 
	"combo": Color8(196, 150, 18, 255),
	"usual": Color8(100, 100, 175, 255) }

func new_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(next: Vector2i, _base_xp: int):
			if not fixed: timer.appear() # show()
			max_value = next.y
			value = next.x)

func update_color(color: String = "combo") -> void: # is_combo: bool, 
	fill.color = COLOR[color] # bg_
	set(KEY, fill)

func finish() -> void: update_color("usual")



extends HBoxContainer

@onready var slot: Label = $slot
@onready var time: PanelContainer = $time

var _hits: HBoxContainer = null
var hits: HBoxContainer:
	get:
		return null #  Works.upload(self, _hits, LoadBus.hits, "hits")

var _xp: Label = null
var xp: Label:
	get: return null # Works.upload(self, _xp, LoadBus.xp, "xp")

func update_meter(duration: float, mx: float) -> void: xp.update_meter(duration, mx)

func update_multiplier(score: float) -> void: xp.update_multiplier(score)

func set_xp_score(group_xp: Node) -> void: xp.set_xp_score(group_xp)

func finish() -> void: xp.finish()




extends Label

@onready var number: ProgressBar = $number
@onready var lasted: ProgressBar = $timing/lasted

const NUMBER: int = 60

func tick(value: int) -> void:
	if value < NUMBER:
		number.text = str(value)
	else:
		number.text = "%d:%02d" % [value / NUMBER, value % NUMBER]
	lasted.value = value




extends HBoxContainer

@onready var status: HBoxContainer = $enemies/margin/status
@onready var enemies: Control = $enemies




extends Control

@onready var title: HBoxContainer = $title
@onready var slots: ColorRect = $slots



extends HBoxContainer

@export var fixed: bool = false

@onready var space: Control = $space
@onready var preset: HBoxContainer = $preset

func _ready() -> void:
	space.title.status.xp.set_fixed(fixed)
	# preset.sets.ap.set_fixed(fixed) #TODO FIXME SET FIXED




extends PanelContainer

@onready var status: Label = $margin/description
@onready var timing: Timer = $hiding
@onready var health: ProgressBar = $health
@onready var aura: ProgressBar = $aura
@onready var slot: Label = $slot

func _ready() -> void:
	timing.timeout.connect(hide)

func reload_timer():
	if not status.visible:
		show()
	timing.start()
	return self

func notify(text: String) -> void:
	status.text = text
	reload_timer().show()

func new_slot(unicode: String) -> void:
	slot.text = unicode
	slot.modulate = Color.WHITE
	create_tween().tween_property(slot, "modulate", Color.TRANSPARENT, 2.0)

func hp_change(next: int) -> void:
	reload_timer().health.value = next

func ap_change(next: int) -> void:
	reload_timer().aura.value = next




extends VSplitContainer

@onready var controls: VBoxContainer = $margin/controls
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

#func _ready() -> void: drag_started.connect(topic.update_stack)


extends VBoxContainer

@onready var next_score: Label = $experience/next_score/count

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			next_score.text = str(value.y - value.x))

#func finish() -> void: pass
#func update_meter() -> void: 


extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get: return update_scroll()

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get: return update_stack()

func update_stack() -> VBoxContainer:
	if _stack == null:
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null #  Works.upload(self, _scroll, Def.ability, "ability")


extends VBoxContainer

@onready var space: Control = $space
@onready var perks: VBoxContainer = $perks
@onready var item: VBoxContainer = $item

func select_hero(party: HeroParty) -> void:
	space.status.preset.sets.skill.select_hero(party)
	item.select_hero(party)


extends HBoxContainer

@onready var title: VBoxContainer = $title
@onready var sets: VBoxContainer = $sets


extends VBoxContainer

@onready var ray: HBoxContainer = $ray
@onready var rock: HBoxContainer = $rock

func select_hero(party: HeroParty) -> void:
	get(party.follower.name).hide()
	get(party.leader.name).show()


extends Control

@onready var status: HBoxContainer = $status
@onready var slots: ColorRect = $description



extends Control

@onready var topic: Control = $topic
@onready var status: HBoxContainer = $status

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get: return Works.upload_at(status, _hp, "hp", Def.mhealth, "hp")

var markers: HFlowContainer:
	get: return null# Works.uploads(self, Def.items, "markers") # TODO SET  MARKERS FREE FROM LINKING

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return null# Works.upload_at(self, status, _hints, Def.hints % "hints", "hints")

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		




extends ProgressBar

@onready var health: ProgressBar = $health
@onready var contested: ProgressBar = self
@onready var caption: PanelContainer = $text # TODO fix caption and interrogate for enemy
@onready var modulator: Node = $modulator
@onready var damage: Label = caption.get_node("damage")
@onready var hits: HBoxContainer = get_node("../margin/status/hits") #$content/hits
@onready var back: TextureRect = damage.get_node("back") # @onready var interrogate: Label = $margin/contents/interrogate
@onready var damages: HBoxContainer = damage.get_node("margin/damage")

@onready var health_back: StyleBoxFlat = health.get("theme_override_styles/background")

func _ready() -> void: caption.health = health
func appear() -> void: modulator.appear(self)
func disappear() -> void: modulator.disappear(self)

func animate() -> void:
	health_back.content_margin_bottom = 0 # TODO TWEEN VALUE HERE
	damage.text = "ONA! - BAM!"

func set_hp(hp: Node) -> void:
	damages.health.text = str(int(hp.contested))
	damages.value.text = str(int(hp.contested - hp.points))
	back.set_value(hp)



extends HBoxContainer

@export var fixed: bool = false
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

# func _update_pause() -> Variant: return Works.upload_hold(self, "holder", _pause, LoadBus.pause, "pause")

var _pause: HBoxContainer = null
var pause: HBoxContainer:
	get: return null # _update_pause()

Def.enemy
var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get: return null # Works.upload_hold(self, "space", _enemy, Def.enemy, "enemy")

var _slots: ColorRect = null
var slots: ColorRect:
	get: return null # Works.upload_at(self, status, _slots, LoadBus.slots, "slots")

#func _ready() -> void:
#	$holder.mouse_entered.connect(_update_pause) #status.xp.set_fixed(fixed)



extends Label

func change(hp: Node) -> void: # text = str(int(hp.contested))
	var delta: int = hp.contested - hp.points # int(
	var op: String = "^" ; if delta < 0: op = ">"
	text = "%d %s %d" % [hp.contested, op, abs(delta)] # int()


extends TextureRect

const MAX: float = 0.95

func set_value(points: Node) -> void:
	var value: float = MAX - MAX * points.points / points.maximum
	texture.fill_from.y = value
	# visible = value < MAX



extends Label

@onready var lamp: Control = $lamp
@onready var back: TextureRect = $back
@onready var margin: MarginContainer = $margin
@onready var timer: Timer = $timer
@onready var hiding: Timer = $hiding

var combos: Node
var health: ProgressBar
var interrogating: bool = false
var _title: String

func set_title(title: String) -> void:
	_title = title
	enemy.text = title

func _ready() -> void:
	timer.timeout.connect(set_disabled_tint)

func set_tint(a: int) -> void:
	lamp.modulate = Color8(255, 255, 255, a) # back.modulate = Color8(255, 255, 255, a)
	margin.modulate = Color8(255, 255, 255, a)

func set_disabled_tint() -> void:
	if not interrogating:
		set_tint(255)
		back.visible = true
		# if combo.fixate_card(health.value, _title): return
		hiding.start()

func show_start() -> void:
	# combo.has_card TODO FIXME add to condition with and
	if timer.is_stopped() and hiding.is_stopped():
		timer.start()
		set_tint(60)
		back.visible = false




extends MarginContainer

@onready var caption: PanelContainer = $title/caption
@onready var animation: Control = $title/animation

func appear(tween: Tween) -> void:
	pass

func disappear(tween: Tween) -> void:
	tween.
	animation
	pass


extends HBoxContainer

enum { DIGIT = 10, MAX = 999 }

@onready var digits: Array[Control] = [$hundred, $ten, $one]

func hide_all() -> void:
	hide()
	for digit in digits: digit.hide_digit()

func set_count(hits: int) -> void:
	if hits > MAX: return
	show() # var x: Array[int] = [100, 10, 1]
	for i in range(0, 3):
		digits[i].set_digit(hits / (DIGIT ** (2 - i)) % DIGIT)


extends Node

@onready var count: Label = $count


extends Control

@onready var margin: Array = [$a, $b, $c]
@onready var timer: Timer = $timer

const MARGIN: int = 25
const TIME: float = 0.6

var delayed: bool = false
var digit: int = 0
var cycle: int = 0

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

func hide_digit() -> void:
	digit = 0
	for m in margin: m.count.text = ''
	delayed = false

func set_disabled_tint() -> void: for i in len(margin): set_hide(i)

func _modulate(tween: Tween, m, color) -> void:
	tween.tween_property(m, "modulate", color, TIME)

func set_hide(n: int) -> void:
	var tween: Tween = create_tween()
	_modulate(tween, margin[n], Color.TRANSPARENT)

func animate(no: int) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(func(v): set_margin(margin[no], v), MARGIN, -MARGIN, TIME)
	timer.start()

func set_margin(m: MarginContainer, v) -> void:
	m.modulate = Color8(255, 255, 255, 255 / MARGIN * (MARGIN - abs(v)))
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)
	if v == 8: delayed = false #cycle = min(cycle + 1, 1) #-20
	# if v <= -25 and delayed: delayed = false

func set_hit_value() -> void:
	margin[cycle].add_theme_constant_override("margin_top", -MARGIN)
	margin[cycle].add_theme_constant_override("margin_bottom", MARGIN)
	margin[cycle].count.text = str(digit)

func set_digit(next: int) -> void:
	if next != digit and not delayed: # and cycle > Defaults.INT
		delayed = true
		digit = next
		margin[cycle].modulate = Color.TRANSPARENT
		set_hit_value() # m
		animate(cycle)
		cycle = (cycle + 1) % len(margin)



extends ProgressBar

@onready var cost: ProgressBar = $cost
@onready var shadow: TextureRect = $shadow
@onready var timer: Timer = $timer

const TIME: int = 1

var fixed: bool = false
var shown: bool = false
var tween: Tween

func set_fixed(state: bool) -> void:
	fixed = state
	if fixed: modulate = Color.WHITE

func use_skill(resource: Node) -> void:
	cost.max_value = resource.maximum
	cost.value = int(resource.points)
	shadow.set_value(resource)
	if not fixed: timer.appear()

func show_cost(points: int, delta: int) -> void:
	value = points
	cost.value = points - delta
	shown = true
	animate_cost()

func hide_cost() -> void:
	shown = false
	value = 0

func animate_cost() -> void:
	if not shown: return
	var next: Color = Color.WHITE
	if self_modulate == Color.WHITE:
		next = Color.BLACK
	tween = create_tween()
	tween.tween_property(self, "self_modulate", next, TIME)
	tween.tween_callback(animate_cost)


extends MarginContainer

@onready var sets: HBoxContainer = $options/sets
@onready var analyze: Button = $options/analyze

func select_hero(party: HeroParty) -> void:
	sets.get(party.leader.name).show()
	sets.get(party.follower.name).hide()


extends HBoxContainer

@onready var ray: HBoxContainer = $ray
@onready var rock: HBoxContainer = $rock



extends VBoxContainer

@onready var ap: ProgressBar = $ap/current
@onready var skill: MarginContainer = $skill

func use_skill(resource: Node) -> void:
	ap.use_skill(resource)
	#ap.cost.max_value = resource.maximum
	#ap.cost.value = int(resource.points)



extends HBoxContainer

@onready var sets: VBoxContainer = $skill/sets




extends VSplitContainer

@onready var ability: VSplitContainer = $ability
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

# func _ready() -> void: drag_started.connect(topic.update_stack)


extends Label

var tools: Dictionary

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_delay(1)
	tween.tween_callback(disappear)

func disappear() -> void:
	tools.combos = null
	queue_free()



extends Button

signal switch_bags(bag: String)

var inventory: Node
var hero: String

func set_inventory(group: Node2D) -> void:
	inventory = group.get(hero).to.inventory

func _ready() -> void:
	pressed.connect(switch)
	if text == "Рок": $icon.hide()

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: trade(cell)

func trade(cell: Control) -> void:
	var slot: int = inventory.logic.find_empty_slot()
	if slot != inventory.logic.items.ui.NONE:
		cell.image.holder = null
		cell.inventory.logic.trade_bags(inventory.logic, cell.slot, slot)

func switch() -> void: switch_bags.emit(hero)



class_name StatusPoints extends Button

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

var cells: Array[int] = []
var inventory: Node

func key() -> String: return "h"

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)

func set_inventory(hero: CharacterBody2D) -> void:
	inventory = hero.to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag and inventory.logic.sorting.fillable(cell, key())
	
func _drop_data(_pos: Vector2, cell: Variant) -> void:
	if cell.drag.ui.logic.sorting.use_as_slot(cell.slot) == 0:
		cell.drag.ui.reset_holder()



extends StatusPoints

func set_inventory(hero: CharacterBody2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.quick_heal)



extends StatusPoints

func key() -> String: return "a"

func set_inventory(hero: Node2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.reload_resource)




extends VBoxContainer

@onready var space: Control = $space
@onready var status: Control = $status

const PIN: Vector2i = Vector2i(0, 15)
const DURATION: int = 2

func toggle(pos: Vector2, clr: Color, feedback: Callable) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(space, "custom_minimum_size", pos, DURATION)
	tween.tween_property(space, "modulate", clr, DURATION)
	tween.tween_callback(feedback)

func shows() -> void:
	space.custom_minimum_size = PIN
	toggle(Vector2.ZERO, Color.WHITE, show)

func hides() -> void:
	toggle(PIN, Color.TRANSPARENT, hide)



extends PanelContainer

@export var ailment: Control = self

func hide_out() -> void:
	ailment.hide()




extends Container

@onready var ray: HFlowContainer = $ray
@onready var rock: HFlowContainer = $rock

func select_hero(group: Node2D) -> void:
	get(group.deploy.party.leader.name).bag.hide()
	var follower: String = group.deploy.party.follower.name
	var ui: HFlowContainer = get(follower)
	ui.bag.show()
	remove_child(ui)
	add_child(ui)



extends HBoxContainer
"""
@export var is_bag: bool = false

@onready var health: Button = $health
@onready var ability: Button = $ability
var bag: Button

func _ready() -> void: 
	if is_bag:
		bag = preload("res://asset/scene/ui/hud/detector/game/menu/inventory/status/shared/bag.tscn").instantiate()
		bag.hero = name
		add_child(bag)
"""



extends MarginContainer

@onready var items: HFlowContainer = $items

# func _ready() -> void: items.set_items(name)




extends HFlowContainer

var _ray: HFlowContainer = null
var ray: HFlowContainer:
	get: upload_bag(_ray, "ray") ; return _ray

var _rock: HFlowContainer = null
var rock: HFlowContainer:
	get: upload_bag(_rock, "rock") ; return _rock

func upload_bag(hero: HFlowContainer, title: String) -> void:
	if hero == null:
		hero = PreloadBus.bag.instantiate() # set("_" + title, hero) if ref won't work
		hero.name = title
		var space: Control = get_node(title)
		space.add_sibling(hero)
		remove_child(space)

var opened: Node

func hides() -> void: get(opened.bag).hide()
func shows() -> void: get(opened.bag).show()

func connect_group(hero: String, group: Node2D, _opened: Node) -> void:
	var ui: HFlowContainer = get(hero).items
	group.get(hero).to.inventory.logic.trade.ui.set_items(ui)
	opened = _opened

func select_hero(group: Node) -> void:
	var leader: String = group.deploy.party.leader.name
	var follower: String = group.deploy.party.follower.name
	get(leader).show()
	var ui: MarginContainer = get(follower)
	ui.visible = opened.other
	remove_child(ui)
	add_child(ui)

func switch(hero: String) -> void:
	if opened.bag == hero:
		get(hero).visible = !get(hero).visible
	else:
		get(opened.bag).hide()
		get(hero).show()



extends VBoxContainer

@onready var bag: HFlowContainer = $bag# $items/bag
@onready var status: HFlowContainer = $status
@onready var sticker: MarginContainer = $sticker

func connect_group(group: Node2D) -> void:
	group.deploy.select_hero.connect(func(_h): status.select_hero(group))





extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get: return update_scroll()

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get: return update_stack()

func update_stack() -> VBoxContainer:
	if _stack == null:
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null #Works.upload(self, _scroll, LoadBus.inventory, "scroll")




extends Button

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

var trade: Node

func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: trade.trades(cell)

@onready var component: HBoxContainer = $component
@onready var title: HBoxContainer = $short/title
@onready var caption: Label = $short/margin/caption
@onready var effect: Label = $effect

func set_item(item: Dictionary) -> void:
	component.describe(item)
	title.set_item(item) #effects.set_effect(item.logic)
	effect.text = item.item.description
	caption.text = item.item.name

func helping() -> void:
	component.hides()
	title.effects.hide()
	caption.text = "Инвентарь, ЛКМ"
	title.effect.text = "Область для осмотра"

func equipment(slots: Array, equip: Dictionary) -> void:
	component.equipment(slots, equip.logic)
	# set_item(equip)

func production(slots: Array) -> void:
	component.production(slots)
	if slots.is_empty():
		helping()
	else:
		set_item(slots.back().item)



extends HBoxContainer

@onready var effect: Label = $effect
@onready var effects: HBoxContainer = $effects

func set_item(item: Dictionary) -> void:
	effect.text = item.item.short
	effects.set_effect(item.logic)


extends HBoxContainer

@onready var aura: PanelContainer = $aura
@onready var resource: PanelContainer = $resource
@onready var no_enemy: PanelContainer = $no_enemy
@onready var no_poison: PanelContainer = $no_poison
@onready var no_cough: PanelContainer = $no_cough

func hides() -> void: for i in get_children(): i.hide()

func saura() -> String:
	aura.show()
	return "aura shown"

func sresource() -> String:
	resource.show()
	return "resource shown"

func set_refill(item: IUse) -> void:
	hides()
	item.imagine(self)

func set_effect(item: Variant) -> void:
	hides()
	var sticker = get(item.effect)
	if sticker:
		sticker.show()



extends HBoxContainer

@onready var status: HBoxContainer = $status
@onready var timing: VBoxContainer = $timing

func set_values(item: IUse) -> void:
	timing.set_power(item)
	status.set_refill(item)

func set_status(item: Variant) -> void:
	status.set_effect(item)
	#if 
	#timing.set_time(item.time)

func set_effect(item: Variant) -> void:
	show()
	if item is IUse:
		set_values(item)
	else:
		set_status(item)



extends VBoxContainer

@onready var effect: Label = $effect
@onready var time: ProgressBar = $time

const PERIOD: float = 60

func a() -> String: return "A"
func r() -> String: return "R"
func ar() -> String: return a() + r()
func both() -> String: return "%d " + ar() + " %d"

func set_time(seconds: int) -> void:
	show()
	if seconds < PERIOD:
		effect.text = "%d s." % seconds
	else:
		effect.text = "%.1f m. " % (seconds / PERIOD)

func set_power(item: IUse) -> void:
	show()
	effect.text = item.describe(self)




extends HFlowContainer

@onready var slots: Array[Node] = get_children()

var _title: HBoxContainer
var title: HBoxContainer:
	get: return Def.lazy(self, _title, Def.title, &"title")

# func _ready() -> void:
	# for i in range(0, HeroInventory.SLOTS): slots[i].slot = i


extends Button

@onready var stand: VBoxContainer = $content
@onready var collapsed: Control = stand.get_node("collapsed")
@onready var selected: Control = stand.get_node("selected")
@onready var preview: Control = stand.get_node("selected/image")

func toggle(selection: bool) -> void:
	collapsed.visible = !selection
	selected.visible = selection

func hide_item() -> void:
	toggle(false)
	preview.hide()

func _ready() -> void:
	mouse_entered.connect(func(): stand.show())
	mouse_exited.connect(func(): stand.hide())

func show_item() -> void:
	toggle(true)
	preview.show()


class_name InventoryItem extends Button

@onready var margin: MarginContainer = $margin

func _ready() -> void: pressed.connect(select_item)

func select_item() -> void:
	margin.view.drag.craft.selection.select_item(margin.view)

func remove_item() -> void: margin.remove_item()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	margin.replace_item(next, prev)

func put_item(slot: Dictionary) -> void: margin.put_item(slot)


extends InventoryItem

# func _get_drag_data(_p) -> InventoryItem: return set_preview(self)
# func _can_drop_data(_p, cell: Variant) -> bool: return cell is InventoryItem
# func _drop_data(_p, cell: Variant) -> void: trades(cell, self)

@onready var color: ColorRect = $margin/selection/fast/color
@onready var back: TextureRect = $margin/selection/fast/back

func _toggle(state: bool) -> void: # progress color: #999999
	color.visible = state
	back.visible = state

func show_selection() -> void: _toggle(true)
func hide_selection() -> void: _toggle(false)

@onready var bar: ProgressBar = $bar
@onready var number: Label = $number

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	show()
	if next == BOUNDARY:
		remove_item()
	else:
		set_values(str(next), next)

func set_values(label: String, next: int) -> void:
	number.text = label
	bar.value = next

func remove_item() -> void: set_values("", 0)



extends InventoryItem

@onready var default: Control = $default

func remove_item() -> void:
	super.remove_item()
	default.show()

func put_item(selected: Dictionary) -> void:
	default.hide()
	super.put_item(selected)





extends Button

@onready var view: TextureRect = $view

func _ready() -> void: pressed.connect(select_item)

func put_item(item: Dictionary) -> void:
	show()
	view.drag.ui.put_item(item, view.image)

func select_item() -> void:
	view.drag.select_item(self)


extends MarginContainer

@onready var view: Control = $view




class_name CellDrag extends TextureRect

@onready var count: Label = $count
@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

const BOUNDARY: int = 1

var slot: int
var drag: Node

func _get_drag_data(_p) -> CellDrag: return drag.ui.set_preview(self)
func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: drag.trades(cell, self)

func remove_item() -> void: # var inventory: Node # TODOT inv
	drag.ui.remove_item(image)
	count.text = ""

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	for item in [next, prev]: put_item(item)

func put_item(item: Dictionary) -> void:
	drag.ui.put_item(item, image)
	set_value(item.x)

func set_value(next: int) -> void:
	count.text = "" if next == BOUNDARY else str(next)



extends Control

@onready var fast: VBoxContainer = $fast
@onready var count: VBoxContainer = $count

func put_item(slot: Dictionary) -> void:
	count.set_value(slot.x)

func remove_item() -> void:
	count.remove_item()


extends VBoxContainer

@onready var color: ColorRect = $color
@onready var back: TextureRect = $back


extends Label

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	text = "" if next == BOUNDARY else str(next)




extends HBoxContainer

#@onready var status: MarginContainer = $ap/margin/combo/status
#@onready var status_caption: Label = status.get_node("caption")
@onready var health: Label = $health/status/margin/hp/health
@onready var damage: Label = $health/status/margin/hp/damage

@onready var status: MarginContainer = $health/status/margin
@onready var back: TextureRect = $health/status/back
@onready var timer: Timer = $timer

const MAX: float = 0.95
#@onready var slots: HBoxContainer = $ap/margin/combo/slots

func _ready() -> void:
	timer.timeout.connect(hide_status)

func hide_status() -> void:
	status.hide()
	back.hide()

func set_hp(hp: Node) -> void:
	status.show()
	
	health.text = str(int(hp.contested))
	damage.text = "-" + str(int(hp.contested - hp.points))
	var value: float = MAX * hp.points / hp.maximum
	back.texture.fill_to.y = value
	back.visible = value > 0
	
	timer.start()


extends MarginContainer

@onready var stack: HFlowContainer = $score/stack



extends Node

@onready var slots: Array = [
	$slot_1, $slot_2, $slot_3, $slot_4
]

# TODO slots

extends HBoxContainer

@onready var slot: Label = $slot

var text: String:
	set(value): slot.text = value




extends Node

@onready var margin: MarginContainer = $margin

var items: Array
var control: bool = true

func _ready() -> void:
	for i in range(1, 11):
		items.append(get_node("item_" + str(i % 10)))



extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

func _ready() -> void:
	return
	helping()
	workspace.cancel.pressed.connect(select_space)

func select_space() -> void:
	slot.margin.view.drag.select_space()

func equipment(slots: Array, item: Dictionary) -> void:
	workspace.stack.equipment(slots, item)

func production(slots: Array) -> void:
	workspace.stack.production(slots)
	if slot.visible and slots.is_empty():
		slot.hide()

func describe(item: Dictionary) -> void:
	workspace.stack.set_item(item)

func put_product(item: Dictionary) -> void: slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()




extends TextureRect

@onready var image: TextureRect = $image

func put_item(icon: String) -> void:
	var path: String = ICONS + icon
	texture = ImageTexture.create_from_image(Image.load_from_file(path))

func hides() -> void:
	image.remove_item()
	hide()

@onready var a: PanelContainer = $a
@onready var b: PanelContainer = $b

# func hides() -> void: for i in [a, b]: i.hides()
func shows() -> void: for i in [a, b]: i.show()

const ICONS: String = "res://asset/resource/media/image/inventory/"

func remove_item() -> void: texture = null


extends GridContainer

@onready var items: Array[Control] = [$a, $b]

func hides() -> void: for i in items: i.hides()

func _iterate(rang: Variant, feedback: Callable) -> void:
	for i in rang:
		feedback.call(i)
		items[i].show()

func equipment(slots: Array, item: IArmor) -> void: #production(slots) # item.equip.size()
	#items[0].put_item(slots[0].item.item.icon)
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func production(slots: Array) -> void:
	hides()
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func describe(item: Dictionary) -> void:
	hides()
	if item.logic is IArmor:
		_iterate(len(item.logic.equip), func(_i): pass)




extends GridContainer

var hero_name: String = "ray"

@onready var skills: Dictionary = {
	"ray": {
		"head": $margin/ray,
		"slap": $margin/ray/left/weapon/knuckles/slap
	},
	"rock": {
		"head": $margin/rock,
		"slap": $margin/rock/left/weapon/knuckles/slap
	},
}

func init_focus() -> void:
	skills[hero_name].slap.grab_focus()

func select_hero(hero: CharacterBody2D) -> void:
	skills[hero_name].head.hide()
	hero_name = hero.name
	skills[hero_name].head.show()




extends VBoxContainer

@onready var first: Control = $first

func append(next: Label) -> void:
	add_child(next)

func insert(next: Label) -> void:
	next.visible_characters = -1
	first.add_sibling(next)


extends VBoxContainer

@onready var timer: Timer = $timer
@onready var chat: Array[Label] = [
	$queued/margin/label, $answer/margin/label
]
@onready var panel: Array[PanelContainer] = [$queued, $answer]

var capacity: int = 0
var messages: Array[String]

func restart() -> void:
	var length: float = messages[0].length()
	timer.stop()
	timer.wait_time = 2.0 + length / 48.0
	timer.start()
	"""
	print("capacity: ", 0)
	print("message: ", messages[0])
	print("wait: ", timer.wait_time)
	"""

func sync_messages() -> void:
	var length: int = 2
	var count: int = min(capacity, length)
	for i in range(1, count + 1):
		panel[length - i].show()
		chat[length - i].text = messages[count - i]

func add_blocks(plot: Array[String]) -> void:
	for block in plot: add_block(block)
	print("messages: ", messages)
	print("capacity: ", capacity)

func add_block(text: String) -> void:
	messages.push_back(text)
	capacity += 1
	#panel[2 - capacity].show()
	if capacity == 1:
		sync_messages()
		restart()

func free_capacity() -> void:
	messages.pop_front()
	capacity -= 1
	if capacity < 2:
		panel[1 - capacity].hide()
	if capacity == 0:
		timer.stop()
	else:
		sync_messages()
		restart()


extends PanelContainer

@onready var 


extends Label

const DURATION: float = 0.5

var title: Label

func say(who: String, key: String) -> void:
	title = $title
	title.text = who
	text = key
	create_tween().tween_property(title, "modulate", Color.TRANSPARENT, DURATION).set_delay(1)





extends VBoxContainer

@onready var scroll: ScrollContainer

func _ready() -> void:
	var s = get_node("../..")
	if s is ScrollContainer:
		scroll = s

func add_childs(stack: VBoxContainer, scene: PackedScene, feedback: Callable) -> PanelContainer:
	var node: PanelContainer = scene.instantiate()
	stack.add_child(node)
	feedback.call(node)
	return node

func add_log(scene: PackedScene, feedback: Callable) -> void:
	var lg: PanelContainer = add_childs(scroll.list.logs.chat, scene, feedback)
	var tween = create_tween()
	tween.tween_property(lg, "modulate", Color.TRANSPARENT, 0.5).set_delay(3)
	tween.tween_callback(func():
		scroll.list.logs.chat.remove_child(lg) # scroll.log
		lg.queue_free())
	add_childs(self, scene, feedback)
	scroll.down()

func set_priority(level: Node, stats: Dictionary) -> void:
	if level.summary != level.prev:
		add_log(PreloadBus.levels, func(node): node.set_priority(level, stats))

func add_item(thing: String) -> void: add_log(PreloadBus.item, func(n): n.chest(thing))
func add_enemy(thing: String) -> void: add_log(PreloadBus.item, func(n): n.analyze(thing))
func add_any(thing: String) -> void: add_log(PreloadBus.item, func(n): n.say(thing))




extends PanelContainer

@onready var hero: VBoxContainer = $hero

func say(who: String, what: String) -> void:
	hero.say(who, what)




extends Label

var items: PackedStringArray = [
	"А что нашлось то тут у нас... %s", "%s? Отдавай сундук!",
	"%s, по сусекам наскреб", "%s с нами", "Тук-тук, кто там? %s",
	"Давно не виделись, %s", "Прошу на борт, %s", "Глянем... %s",
	"Вот это %s, я понимаю", "%s моей мечты",
	"%s... а подтираться этим можно?"]

func say(message: String, params: Array = []) -> void:
	text = message % params

func chest(item: String) -> void:
	print("ADD ITEM = ", item)
	say(items.pick_random(), [item])

func analyze(enemy: String) -> void:
	say("Сведения о %s добавлены в базу данных", [enemy])



extends Control

enum { MAX = 45, OFFSET = 30, DEGREE = 60 }

@export_range(3, 20, 1) var sides: int = 6

@onready var centered: Rect2 = Rect2(custom_minimum_size / 2, custom_minimum_size)

var colors: Dictionary = {
	"line": clr(28, 53), "polygon": clr(25, 25), "dots": [clr(127, 127), clr(78, 156), clr(135, 255)]
}
var portion: Array[float] = []
var adds: Array[int] = []
var points: PackedVector2Array
var show_stats: bool = false
var show_hex: bool = false

func clr(rg: int, b: int) -> Color: return Color8(rg, rg, b, 255)

func set_stats(stats: Array, delta: Array) -> void:
	for p in MakeStats.hexagon():
		portion.append(min(stats[p] / float(MAX), 1))
		adds.append(delta[p])
	set_hex()
	queue_redraw()

func draw_point(point: Vector2, add: int) -> void:
	if add == 0: return
	add = min(colors.dots.size(), add)
	var dot: Color = colors.dots[add - 1]
	add = min(2, add)
	draw_rect(Rect2(point, Vector2(add, add)), dot)

func reveal_stats() -> void:
	show_stats = true
	queue_redraw()

func _draw() -> void:
	if show_hex:
		draw_colored_polygon(points, colors.polygon)
	if show_stats:
		draw_polyline(points, colors.line, 1)
		var j: int = 0
		for i in range(0, len(points), 2):
			draw_point(points[i], adds[j])
			j += 1

func set_hex() -> void:
	points = []
	var pos: Vector2 = hex_corner(0)
	points.append(pos)
	for i in range(1, sides):
		var iside: Vector2 = hex_corner(i)
		points.append(iside)
		points.append(iside)
	points.append(pos)
	show_hex = true
	
func hex_corner(i: int) -> Vector2:
	var rad: float = deg_to_rad(DEGREE * i - OFFSET)
	return centered.position + portion[i] * centered.size * Vector2(cos(rad), sin(rad))



extends PanelContainer

@onready var heroes: HFlowContainer = $margin/hero

func set_priority(level: Node, stats: Dictionary) -> void:
	for hero in heroes.get_children():
		hero.set_priority(level, stats)


extends HBoxContainer

@onready var priority: VBoxContainer = $priority
@onready var stats: VBoxContainer = $stats

func _ready() -> void: stats.hero.set_caption(name)

func set_priority(level: Node, numbers: Dictionary) -> void:
	var hero: Dictionary = level.summary.hero[name]
	var prev: Dictionary = level.prev.hero[name]
	if hero.at != prev.at:
		stats.hero.set_next_priority(priority.names[hero.at])
	priority.set_priority(prev.at, hero.of[prev.at])
	stats.number.set_stats(numbers.stats[name], numbers.prev[name])



extends VBoxContainer

@onready var caption: Label = $caption
@onready var level: Label = $level

var names: Array[String] = ["Стремление", "Выдержка", "Стойкость"]

func set_priority(at: int, lv: int) -> void:
	caption.text = names[at]
	level.text = str(lv)



extends RichTextLabel

@onready var add: MarginContainer = $add
@onready var next: MarginContainer = $next
@onready var hexagon: Control = $hexagon

#func _ready() -> void:
#	for r in [add, next, hexagon]: reveal.timeout.connect(r.reveal_stats)

func set_stats(now: Array, prev: Array) -> void:
	var stats: Dictionary = { "now": now, "delta": MakeStats.delta(now, prev) }
	# add.set_stats(stats)
	next.set_stats(stats)
	hexagon.set_stats(stats.now, stats.delta)



extends MarginContainer

@onready var offence: VBoxContainer = $stats/offence
@onready var defence: VBoxContainer = $stats/defence
@onready var points: VBoxContainer = $stats/points

func _reveal(feedback: Callable) -> void:
	for type in ["offence", "defence", "points"]:
		feedback.call(get(type))

func set_stats(stats: Dictionary) -> void:
	_reveal(func(t): t.set_stats(stats))

func reveal_stats() -> void:
	_reveal(func(t): t.reveal_stats())



extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

var now: Array[int] = [0, 0]

func set_stats(stats: Dictionary) -> void:  # ["power", "health"]
	for i in range(0, len(group)):
		now[i] = stats.now[keys[i]]
		group[i].text = str(now[i])# - stats.delta[i])

func reveal_stats() -> void:
	for i in range(0, len(group)):
		pass # TODO FIXME SEPARATOR
		# group[i].text = str(now[i])



extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

func _reveal(feedback: Callable) -> void:
	for i in range(0, len(group)):
		feedback.call(i, group[i]) # .value

func set_stats(stats: Dictionary) -> void:
	_reveal(func(i, v):
		var value: int = stats.delta[keys[i]]
		v.text = str(value))

func reveal_stats() -> void:
	_reveal(func(i, v): pass  )# v.hide()) # TODO FIXME stats level up hide



extends HBoxContainer

@onready var caption: Label = get_node("caption")
@onready var next: HBoxContainer = $next
@onready var priority: Label = next.get_node("priority")

var heroes: Dictionary = { "ray": "Рей", "rock": "Рок" }

func set_caption(hero: String) -> void:
	caption.text = heroes[hero]

func set_next_priority(caption: String) -> void:
	priority.text = caption
	next.show()


extends VBoxContainer

@onready var caption: HBoxContainer = $caption
@onready var number: MarginContainer = $number
@onready var hero: HBoxContainer = $hero



extends VBoxContainer

func append(next: Label) -> void: add_child(next)


extends VBoxContainer

@onready var chat: VBoxContainer = $chat
@onready var logs: VBoxContainer = $logs
@onready var temp: VBoxContainer = $temp



extends ScrollContainer

@onready var list: VBoxContainer = $list

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)





extends PanelContainer

var _stack: HBoxContainer = null
var stack: HBoxContainer:
	get: return null # Works.upload(self, _stack, LoadBus.hints % name, name)



extends VBoxContainer

@onready var space: Control = $space
@onready var bottom: Control = $bottom


#@onready var chats: PanelContainer = $chats
#@onready var help: PanelContainer = $help



extends Control

@onready var preview: HBoxContainer = $preview




extends Button

@export var path: String = ""

func _ready() -> void:
	var chats: BoxContainer = get_node(path)
	if not chats: return
	chats.show_toggle.connect(func(state):
		visible = state)
	#print("chats: ", chats.name)
	#print("stop")
	pressed.connect(chats.show_from_panel)



extends ScrollContainer

# @onready var hints: VBoxContainer = $content/hints
@onready var books: VBoxContainer = $content/books

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return _hints

# @onready var ui: Array = hints.kind.motion.get_children()
# @onready var count: int = len(ui)
@onready var list: VBoxContainer = $list

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)

var select: int = 0
"""
func hide_caption(no: int) -> void:
	ui[no].margin.caption.hide()

func _ready() -> void:
	for i in count:
		hide_caption(i)
		ui[i].showcase.pressed.connect(func():
			if not ui[i].helpiong:
				_change(i))

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	hide_caption(select)
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(_event: InputEvent) -> void:
	for i in [["list_up", -1], ["list_down", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
"""




extends VBoxContainer

@onready var kind: VBoxContainer = $category
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

@export var casual: bool = false

var types: Array[String]

func _ready() -> void:
	kind.fight.visible = !casual

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func clear_progress() -> void:
	for type in types:
		for ref in blackboard.g("ref")[type].values():
			if ref.visible: ref.hide_delayed()

func progress(head: String, body: String) -> void:
	behavior.tick(self, blackboard.s("head", head).s("body", body))

func get_category() -> Dictionary:
	var result: Dictionary = {}
	for i in kind.get_children():
		result[i.name] = i.get_category()
		types.append(i.name)
	return result

func set_preview(group: Node2D, prev: HelpPreview) -> void:
	var help: Dictionary = group.camera.analyze.get_analyze()
	blackboard.s("hide", true).s("show", prev.clone()).s("ref", get_category()).s(
		"progress", []).s("preview", prev.help).s("analyze", help)



extends ScrollContainer

@onready var options: VBoxContainer = $options

var scroll: int = 0

func _physics_process(_delta: float) -> void:
	scroll_vertical += scroll * 10

func _input(_event: InputEvent) -> void:
	scroll = int(Input.get_axis("list_up", "list_down"))




extends BehaviorBlackboard

func toggle_value(key: String) -> BehaviorBlackboard:
	return s(key, !g(key))


extends BehaviorAction

func resolve_showcase(body, show, preview, analyze):
	print("preview: ", preview[body], ", body: ", body, ", collide: ", analyze.has(body) and analyze[body].is_colliding())
	show[body] = preview[body]
	if show[body] and analyze.has(body):
		show[body] = analyze[body].is_colliding()

func tick(mark: Tick) -> int:
	var can_show: bool = false
	var board: BehaviorBlackboard = mark.blackboard

	var preview: Dictionary = board.g("preview")
	var show: Dictionary = board.g("show")
	var analyze: Dictionary = board.g("analyze")

	for head in preview.keys():
		for body in preview[head].keys():
			can_show = can_show or resolve_showcase(
				body, show[head], preview[head], analyze[head])
	
	return OK if can_show else FAILED



extends BehaviorAction

const EMPTY: String = ""

func tick(mark: Tick) -> int:
	var board: BehaviorBlackboard = mark.blackboard
	var head: String = board.g("head")
	if head == EMPTY: return FAILED
	
	var body: String = board.g("body")
	var ref: PanelContainer = board.g("ref")[head][body]
	ref.show_delayed()
	
	board.g("preview")[head][body] = true
	board.s("head", EMPTY).s("body", EMPTY)
	return OK



extends BehaviorAction

func tick(mark: Tick) -> int:
	if not mark.blackboard.g("hide"): return FAILED
	
	var show: Dictionary = mark.blackboard.g("ref")
	
	for head in ["motion", "action", "reason"]:
		for ref in show[head].values(): ref.hide()
		
	return OK



extends BehaviorAction

@onready var category: String = get_parent().name

func _gets(mark: Tick, key: String) -> Variant:
	return mark.blackboard.g("show")[category][name]

func tick(mark: Tick) -> int:
	if _gets(mark, "show"): _gets(mark, "ref").show()
	return OK





extends VBoxContainer

class_name HintsCategory

func get_acts() -> Array[String]:
	var acts: Array[String] = []
	for i in get_children(): acts.append(i.name)
	return acts

func get_category() -> Dictionary:
	var category: Dictionary = {}
	for act in get_acts():
		category[act] = get_node(act)
	return category


extends VBoxContainer

@onready var motion: VBoxContainer = $motion
@onready var action: VBoxContainer = $action
@onready var reason: VBoxContainer = $reason
@onready var fight: VBoxContainer = $fight
@onready var common: VBoxContainer = $common

"""
@onready var scroll: ScrollContainer = $scroll
@onready var ui: Array = scroll.get_node("stack").get_children()
@onready var count: int = len(ui)

var select: int = 0

func hide_caption(no: int) -> void:
	ui[no].margin.caption.hide()

func _ready() -> void:
	for i in count:
		hide_caption(i)
		ui[i].showcase.pressed.connect(func():
			if not ui[i].helping:
				_change(i))
		ui[i].update_hint(Def.ARRAY)

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	hide_caption(select)
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(event: InputEvent) -> void:
	for i in [["list_up", -1], ["list_down", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
"""




extends PanelContainer

@export var help: HelpHint

@onready var caption: Label = $stack/body/caption
@onready var head: Label = $stack/head/caption/text

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func _ready() -> void:
	head.text = help.head # TODO FIXME HELP HINT
	# caption.text = help.body % help.keyboard

func _change_state(color: Color) -> void:
	create_tween().tween_property(self, "modulate", color, 0.5)

func show_delayed() -> void:
	modulate = Color.TRANSPARENT
	show()
	_change_state(Color.WHITE)
	
func hide_delayed() -> void:
	_change_state(Color.TRANSPARENT)
	await get_tree().create_timer(1).timeout
	hide()
	modulate = Color.WHITE

func get_gamepad_hint() -> String:
	var device: String = Input.get_joy_name(0).to_lower()
	var hint: String = help.body

	if device == "": return hint % help.keyboard

	var i: int = help.get_gamepad_type(device)
	var hints: Array[String] = help.gamepad[i].hints

	if help.gamepad.size() == 1:
		hint = hint % hints[0]
	else:
		hint = hint % hints

	return hint

func sync_control_hint(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		caption.text = get_gamepad_hint()
	else:
		pass # TODO FIXME HELP 
		# caption.text = help.body % help.keyboard



extends VBoxContainer

@onready var analyze: Button = $analyze
@onready var books: Button = $books




extends Panel

@onready var borders: StyleBoxFlat = get("theme_override_styles/panel")
@onready var image: TextureRect = $image # @onready var borders: PanelContainer = $borders

const DURATION: float = 1.0 # const DURATION: float = 1.0

const animations: PackedStringArray = ["look", "rage", "grin", "smile", "amaze",
	"tired", "but", "sign", "confirm", "respect", "anger", "play", "rain"]
const keys: String = "LRGSATBNCPEYI"

func show_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.WHITE, DURATION)

func hide_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.TRANSPARENT, DURATION)
	borders.image.stop()

func set_animation(caption: String) -> void:
	if not borders.image.playing: show_animation()
	borders.image.play(caption)

func set_environment(state: bool) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	var bg: StringName; var border: StringName
	if state: bg = &"#0f0f0f" ; border = &"#dcdcdc"
	else: bg = &"#dcdcdc" ; border = &"#0f0f0f"
	tween.tween_property(borders, ^"bg_color", Color(bg), DURATION).set_delay(DURATION)
	tween.tween_property(borders, ^"border_color", Color(border), DURATION).set_delay(DURATION)



extends Control

@onready var talk: MarginContainer = $talk
@onready var controls: MarginContainer = $controls



extends HFlowContainer

@onready var heroes: Dictionary = { "ray": $ray, "rock": $rock }




extends HBoxContainer

@export var fixed: bool = false

@onready var ray: ProgressBar = $ray/hp
@onready var rock: ProgressBar = $rock/hp
@onready var timer: Timer = $timer

var control: bool:
	set(value):
		ray.health.visible = value
		rock.health.visible = value

func select(_party: HeroParty) -> void:
	pass
	#get(party.leader.name).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#get(party.follower.name).size_flags_horizontal = Control.SIZE_FILL

func disappear() -> void:
	if not fixed: timer.disappear() #hide()
	for hero in [ray, rock]: hero.health.hide()

func change(hero: String, hp: Node) -> void:
	if not fixed: timer.appear() #show()
	
	get(hero).hp.change(hp)
	timer.start()



extends HBoxContainer

@onready var hp: ProgressBar = $hp

var _ailments: HBoxContainer = null
var ailments: HBoxContainer:
	get:
		if _ailments == null:
			_ailments = get_parent().ailments.instantiate()
			add_child(_ailments)
		return _ailments


extends ProgressBar # @export var right: bool = false

@onready var health: Label = $health
@onready var back: TextureRect = $back

const MAX: float = 0.99

var _litmus: HBoxContainer = null
var litmus: HBoxContainer:
	get:
		if _litmus == null:
			_litmus = get_parent().litmus.instantiate()
			var space: Control = $control
			space.add_sibling(_litmus)
			remove_child(space)
		return _litmus

func change(hp: Node) -> void:
	value = hp.points ; show() #health.change(hp)
	health.change(hp)
	var portion: float = hp.points / hp.maximum
	back.texture.fill_to.x = 0.07 + MAX * portion



extends MarginContainer

#@onready var status: HBoxContainer = $status
@onready var hp: HBoxContainer = $hp
