extends CanvasLayer

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

@onready var see: Panel = $see
@onready var work: Node = $work
@onready var link: Node = $link

func first_focus() -> void: see.first_focus()

func set_transitions(menu: CanvasLayer, sound: CanvasLayer) -> void:
	see.topics.tabs.set_back(self, menu)
	see.topics.options.set_soundtrack_transition(self, sound)

func _ready() -> void:
	see.topics.tabs.caption.set_shortcut(self)
	see.topics.options.set_transition(self)
	link.connect_controls(see, work)


extends Node

func controls(s: Node, op: HFlowContainer, work: Node) -> void:
	s.sets(op, work.experience.game.ost, [
		["listen", "SLFL", "SLTH"], ["repeat", "SOFF", "SON"]])


extends Node

var s: Node

func sect_logic(op: HFlowContainer, logic: Node) -> void:
	s.p.n(".")
	s.sets(op, logic, [["screen", "SWND", "SFSC"]])
	#["genre", "SRPG", "SATN"]
	s.select(op, ["interface", "imin", "iadaptive", "ifull", "ifixed"], logic, s.p.p("interface").d)

func controls(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	s.select(op, ["language", "lenglish", "lrussian"], work.experience.interface.logic, s.p.p("interface").s().d)
	sect_logic(op, work.experience.interface.logic)
	sections(op, main, work)
	s.tap(op, "damage", main.status.sticker.hp, s.p.p("control").t().d)

func controls_hero(group: Node2D, main: VBoxContainer, combo: Node) -> void:
	for hero in group.deploy.party.heroes:
		hero.logic.work.input.topdown.actions.combo = combo
	# main.topic.space.title.enemies.enemy.caption.combo = combo # TODO FIXME enemy

func sections(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	var combo: Node = work.experience.game.combo
	controls_hero(work.get_node("../../../group"), main, combo)
	s.select(op, ["combo", "ctoggle", "ccount"], combo, s.p.p("control").n("status").s(true).d)


extends Node

var s: Node

func controls(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	s.tap(op, "genre", work.experience.game.logic, s.p.p("genre").n().t("SRPG", "SATN").d)
	#s.tap(op, "difficulty", work.experience.game.combo, s.p.p("control").t().d)
	s.tap(op, "quotes", main.preview.chats.list.temp.quotes, s.p.d)
	s.select(op, ["difficulty", "dcasual", "dsuitable"], work.experience.game.combo, s.p.p("control").s().d)
	#sections(op, main, work)



extends Node

@onready var sound: Node = $sound
@onready var interface: Node = $interface
@onready var game: Node = $game
@onready var accessibility: Node = $accessibility

func controls(ui: Control, see: Control, work: Node) -> void:
	var xp: VBoxContainer = see.topics.options.game.experience
	var main: VBoxContainer = ui.game.priorities.stats.inventory.ability.controls
	
	for i in ["pplayer", "pinterface"]:
		work.experience.interface.logic.get(i).s = work.experience.store
	for i in [interface, game]: i.s = work.experience.store
	
	game.controls(xp.experience.options, main, work)
	interface.controls(xp.interface.options, main, work)
	sound.controls(work.experience.store, xp.sound.options, work)
	accessibility.controls(work.experience.store, xp.accessibility.options, work)


extends Node

func controls(s: Node, op: HFlowContainer, work: Node) -> void:
	s.sets(op, work.experience.game.vendor, [
		["order_a", "AB", "BA"], ["order_x", "XY", "YX"],
		["reorder", "XA", "AX"], ["vendor", "SXBX", "SNTD"],
		["press", "SOFF", "SON"]])




extends Node

var t: Node

func controls(buttons: Array) -> void: # func enter() -> Callable: return resolve.t.set_button_input
	t.finish()
	t.logic.set_input_action(buttons)
	t.set_final_input(buttons)
	# interrupt()
	await get_tree().create_timer(0.1).timeout
	t.focus(t.topic, "grab")

func interrupt() -> void:
	t.logic.mode.input.interrupt()

func option(button: Button, named: String, machine: int) -> Callable:
	return func():
		interrupt()
		t.focus(button, "release")
		t.logic.set_device(machine)
		t.logic.set_caption(named)
		t.set_title()


extends Node

var mode: Node
var option: String:
	get: return mode.input.link.option

const MASK: int = 1
const KEY: String = "MASK"

func activate(type: String, mask: int) -> Callable:
	return func(): mode.select(type, mask)

func join(sequence: Array) -> String:
	return mode.type.separator.join(sequence)

func set_device(machine: int) -> void:
	mode.device.set_as(machine)

func set_input_action(buttons: Array) -> void:
	mode.buttons.set_action(option, buttons)

func set_caption(caption: String) -> void:
	mode.input.link.option = caption

func valid(key: String) -> bool: return not key == KEY

func custom_mask(modes: Dictionary, named: String) -> int:
	if not modes.has(KEY): return MASK
	if not modes[KEY].has(named): return MASK
	return modes[KEY][named]

func connects(options: Node) -> void:
	mode.interrupts(options.t.finish)
	mode.connects(options.t.set_button_input, options.controls)


extends Node

var t: Node

func connects(ui: Button, type: String, mask: int) -> void:
	ui.pressed.connect(t.activate(type, mask))

func logic(caption: String, type: String, mask: int) -> void:
	connects(t.phrase(t.of(caption)), type, mask)

func option(named: String) -> void:
	t.set_title()
	t.set_caption(named)



extends Node
"""
@onready var devices: Node = $devices
@onready var experience: Node = $experience

func _card_hint(card: Control, determine: Node) -> Callable:
	return func(): card.translate(determine.selected)

func connect_ui(work: Node, ui: VBoxContainer) -> void:
	var l: Node = work.experience.language
	var d: Node = work.controls.determine
	for card in ui.get_children():
		l.update.connect(_card_hint(card, d))
		d.hints.connect(_card_hint(card, d))

func connect_interrupt(tabs: VFlowContainer, m: Node) -> void:
	for i in [tabs.caption.experience, tabs.exit]:
		i.pressed.connect(m.mode.input.interrupt)

func connect_controls(ui: Panel, work: Node) -> void:
	var manage: VBoxContainer = ui.topics.options.controls.management
	var m: Node = work.controls.manage
	devices.buttons.t.management = manage
	devices.buttons.t.logic.mode = m.mode
	var device: Node = m.mode.device
	devices.buttons.connect_signals()
	for i in len(device.types):
		devices.get("connect_" + device.names[i]).call(device.types[i])
	connect_interrupt(ui.topics.tabs, m)
	m.mode.keys = work.controls.keys
	m.mouse.manage = m
	m.keyboard.sequence.input = m.mode.input
	m.gamepad.button.manage = m

func controls(ui: Control) -> void:
	var s: CanvasLayer = get_parent()
	# for i in [ui.ui]: connect_ui(s.work, i)w
	connect_controls(s.see, s.work)
	experience.controls(ui, s.see, s.work)
	for p in s.get_node("../../group").deploy.party:
		p.to.topdown.actions.combo = s.work.experience.game.combo
	# s.enemy_1.caption.combo = s.work.experience.game.combo
"""



extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

enum { M = 0, S = 1 }

func mask_hot_keys(keys: Dictionary, agg: Dictionary) -> Dictionary:
	keys.MASK = {}
	for key in keys.ALL: keys.MASK[key] = agg[key].size()
	return keys

func movement() -> Array: return ["forward", "left", "backward", "right"]
func skills() -> Array: return ["hands", "legs", "skill_1", "skill_2"]
func luggage() -> Array: return ["inventory", "equipment", "ability", "priorities"]
func subjects() -> Array: return ["inventory_prev", "inventory_next", "fire", "combo"]
func quick() -> Array: return ["team", "group", "quick_heal", "quick_refresh"]
func aggregated() -> Dictionary:
	return { "luggage": luggage(), "movement": movement(), "skills": skills(), "subjects": subjects(), "quick": quick() }

func connect_mouse(type: int) -> void:
	var agg: Dictionary = { "subjects": subjects(), "skills": skills() }
	var keys: Dictionary = {
		"HOT": ["movement"] + agg.skills + agg.subjects, "ALL": ["skills", "subjects"],
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)

func connect_keyboard(type: int) -> void:
	var agg: Dictionary = aggregated()
	agg.options = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	var keys: Dictionary = {
		"ALT": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.options + agg.quick + agg.subjects,
		"AGG": ["movement", "skills"], "ALL": ["luggage", "options", "quick", "subjects"]
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)

func connect_gamepad(type: int) -> void:
	var agg: Dictionary = aggregated()
	var keys: Dictionary = {
		"ONE": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.subjects + agg.quick,
		"AGG": ["movement", "targeting", "subjects"],
		"ALL": ["quick"]
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)



extends Node

@onready var t: Node = $t
@onready var options: Node = $options

func _ready() -> void: options.t = t

func connect_button(button: Button, named: String) -> void:
	button.pressed.connect(options.option(button, named, t.machine))

func connect_footer(modes: Dictionary) -> void:
	for key in modes: for n in modes[key]:
		connect_button(t.phrase(t.of(n)), n)

func connect_logic(modes: Dictionary, key: String) -> void:
	for n in modes[key]:
		t.connects(n, key, t.logic.custom_mask(modes, n))

func connect_modes(modes: Dictionary) -> void:
	for key in modes: if t.logic.valid(key): connect_logic(modes, key)

func connect_signals() -> void: t.logic.connects(options)

func connect_all(keys: Dictionary, machine: int, agg: Dictionary) -> void:
	t.logic.mode.device.device = machine
	aggregate(agg)
	connect_footer(keys)
	connect_modes(keys)

func aggregate(agg: Dictionary) -> void:
	for c in agg: t.of(c).connect_collapsing(agg[c], t)




extends Node

@onready var logic: Node = $logic

var management: VBoxContainer
var ui: VBoxContainer:
	get: return management.get(logic.mode.device.named)
var machine: int:
	get: return logic.mode.device.device
var topic: Button:
	get: return phrase(of(logic.option))
var aggregate: Array = Def.ARRAY

func finish() -> void:
	ui.footer.finish_input()

func set_title() -> void:
	ui.footer.title = topic.text

func set_aggregate(next: Array) -> void:
	logic.mode.aggregate = next

func set_button_input(buttons: Array) -> void:
	logic.mode.footer_status(ui.footer, logic.join(buttons))

func set_final_input(buttons: Array) -> void:
	status(of(logic.option)).text = logic.join(buttons)
	set_aggregate(Def.ARRAY)

func of(caption: String) -> Variant:
	var r = ui.options.get_node(caption)
	return r # ui.options.get_node(caption)

func phrase(b: Variant) -> Button:
	return b if b is Button else b.enter

func status(b: Variant) -> Variant:
	return b.get_node("status") if b is Button else b.collapse

func connects(caption: String, type: String, mask: int) -> void:
	phrase(of(caption)).pressed.connect(logic.activate(type, mask))

func focus(b: Button, type: String) -> void:
	b.get(type + "_focus").call() # b.disabled = state # false

func option(named: String) -> void:
	set_title()
	logic.set_caption(named)





extends Panel

# @onready var topics: HBoxContainer = $margin/topics

# func first_focus() -> void:
# 	topics.content.options.game.experience.sound.options.music.submit.grab_focus()


extends VFlowContainer

@onready var caption: Control = $caption
@onready var exit: Control = $exit

func set_back(settings: CanvasLayer, menu: CanvasLayer) -> void:
	exit.pressed.connect(func():
		settings.hide()
		menu.detector.pause.show()
	)


extends HBoxContainer

@onready var options: VBoxContainer = $content/options
@onready var tabs: VFlowContainer = $tabs/options

func _ready() -> void:
	tabs.caption.set_transition(options)




extends MarginContainer

@onready var items: Node = $items
@onready var management: VBoxContainer = $management
@onready var topic: VBoxContainer = get_child(0)


extends MarginContainer

@onready var items: Node = $items
@onready var experience: VBoxContainer = $experience
@onready var topic: VBoxContainer = get_child(0)


extends VBoxContainer

"""
@onready var sound: VBoxContainer = $sound
@onready var experience: VBoxContainer = $experience
@onready var interface: VBoxContainer = $interface
@onready var accessibility: VBoxContainer = $accessibility
@onready var stats: VBoxContainer = $stats
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [sound.get_node("header"), stats.get_node("header"),
		experience.get_node("header"), interface.get_node("header"),
		sound.options.music.submit, stats.get_node("header")]



@onready var game: MarginContainer = $game
@onready var controls: MarginContainer = $controls

func switch_controls() -> void:
	game.hide()
	controls.show()

func switch_experience() -> void:
	controls.hide()
	game.show()

func set_transition(hud: CanvasLayer) -> void:
	game.items.set_transition(hud, game)
	controls.items.set_transition(hud, controls)

func set_soundtrack_transition(settings: CanvasLayer, sound: CanvasLayer) -> void:
	var experience: VBoxContainer = game.get_node("experience")
	experience.sound.options.set_soundtrack_transition(settings, sound)
"""




extends Button

@onready var topic: VBoxContainer = get_node("../content")

func _toggle_content() -> void:
	topic.visible = !topic.visible



extends Node

@onready var timing: Node = $timing
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func setup_items(items: Node) -> void:
	timing.space_trigger.connect(items.set_space)
	timing.first.connect(items.first)
	timing.last.connect(items.last)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		gamepad.set_button(event, self)
	if event is InputEventJoypadMotion:
		gamepad.set_motion(event, self)
	if event is InputEventKey:
		keyboard.set_focus(event, self)


extends Node

signal space_trigger(selection: int, system: int)
signal select(value: int)
signal preview(value: int)
signal first()
signal last()

@onready var finish: Timer = $finish
@onready var action: ActionTimer = $action
@onready var mods: Node = $mods

var MAX: int = 100
var _value: int = 0

func next_digit() -> int: return _value * 10
func set_first() -> void: first.emit()
func set_last() -> void: last.emit()
func set_space(selection: int, system: int) -> void:
	space_trigger.emit(selection, system)

func set_number(no: int) -> void:
	_value = next_digit() + no
	mods.set_bit(0, false)
	#mods.set_bit(5, false)
	#mods.space = 0
	preview.emit(_value)

func start_timers() -> void:
	finish.start()
	action.start()

func set_focus(no: int) -> void:
	if mods.get_bit(0) and next_digit() < MAX:
		set_number(no)
		start_timers()

func _ready() -> void:
	action.timeout.connect(_continue_input)

func _continue_input() -> void:
	action.stop()
	mods.allow_input()

func _reset() -> void:
	print("VALUE: ", _value)
	if _value != 0:
		select.emit(_value)
		_value = 0



extends Node

#signal space_trigger(modifier: int, system: int)

var _modifier: BitMap = BitMap.new()
#var space: int = 0
# var system: int = 4

enum ACTIVE { LEFT = 1, RIGHT = 2 }

func _ready() -> void:
	_modifier.create(Vector2i(6, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, 0)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, 0, bit)

func allow_input() -> void:
	set_bit(0, true)
	#check_spaces()

#func set_space(selection: int, system: int) -> void:
	#space_trigger.emit(selection, system)

"""
func check_spaces() -> void:
	if space != 0:
		space_trigger.emit(space, system)
		space = 0
"""

func get_trigger() -> int:
	if get_bit(ACTIVE.LEFT): return 0
	if get_bit(ACTIVE.RIGHT): return 5
	return -1



extends Node

func set_space(text: String, key: String, timing: Node) -> void:
	text = text.replace(key, "")
	if text.is_valid_int():
		timing.set_space(int(text), 10)

func special_focus(key: int, timing: Node) -> void:
	match key:
		KEY_HOME: timing.set_first()
		KEY_END: timing.set_last()

func set_focus(event: InputEventKey, focus: Node) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	var key: String = "Ctrl+"
	var timing: Node = focus.timing
	
	if text.contains(key):
		set_space(text, key, timing)
	elif text.is_valid_int():
		timing.set_focus(int(text))
	else:
		special_focus(event.keycode, timing)



extends Node

var _system: int = 6
var _special: Callable = set_focus
var special: bool:
	set(value):
		if value: _set_system_for_special(4, set_special)
		else: _set_system_for_special(6, set_focus)

enum { LT = 4, RT = 5, LB = 9, RB = 10, Y = 2, X = 3 }

func _set_system_for_special(digits: int, feedback: Callable) -> void:
	_system = digits
	_special = feedback

func _set_axis_pressed(timing: Node, active: Vector2i, base: int) -> void:
	var is_based: bool = timing.mods.get_bit(active.x)
	if is_based:
		timing.set_focus(base + 3)
	else:
		timing.mods.set_bit(active.x, true)
		timing.start_timers()
	timing.mods.set_bit(5, !is_based)

func _set_axis_released(timing: Node, active: Vector2i) -> void:
	timing.mods.set_bit(active.y, false)
	if not timing.mods.get_bit(active.x) and timing.mods.get_bit(5):
		timing.mods.set_bit(5, false)
		timing.set_space(active.y + 2, _system)

func set_base(base: int, active: Vector2i, event: InputEvent, timing: Node) -> void:
	if event.is_pressed():
		_set_axis_pressed(timing, active, base)
	elif event.is_released():
		_set_axis_released(timing, active)

func set_based_focus(timing: Node, modifier: int) -> bool:
	timing.mods.set_bit(5, false)
	var base: int = timing.mods.get_trigger()
	var is_based: bool = base != -1
	if is_based: timing.set_focus(base + modifier)
	return is_based

func set_focus(timing: Node, modifier: int) -> void:
	if not set_based_focus(timing, modifier):
		timing.set_space(modifier + 1, _system)
		#timing.mods.space = modifier + space
		#timing.start_timers()

func set_special(timing: Node, modifier: int) -> void:
	if set_based_focus(timing, modifier):
		match modifier:
			4: timing.first.emit()
			5: timing.last.emit()

func set_button(event: InputEventJoypadButton, focus: Node) -> void:
	if event.is_pressed():
		match event.button_index:
			LB: set_focus(focus.timing, 1)
			RB: set_focus(focus.timing, 2)
			X: _special.call(focus.timing, 4)
			Y: _special.call(focus.timing, 5)

func set_motion(event: InputEventJoypadMotion, focus: Node) -> void:
	match event.axis:
		LT: set_base(5, Vector2i(2, 1), event, focus.timing)
		RT: set_base(0, Vector2i(1, 2), event, focus.timing)





extends Node

class_name FocusedItems
"""
var _topics: Array[Control] = []
var grabbed: Array[HSlider] = []
var _items: Array[Array] = []
var _focus: Node
var _space: int = 0
var space: int:
	get: return _space


func all_released() -> bool:
	var released: bool = true
	for slider in _grabbed:
		released = released and slider.released
	return released

func _grab_focus(selection: int) -> void:
	_items[_space][selection].grab_focus()

func set_focus(selection: int) -> void:
	_grab_focus(clampi(selection - 1, 0, _items[_space].size() - 1))

func first() -> void: _grab_focus(0)
func last() -> void: _grab_focus(-1)

func set_space(selection: int, _system: int) -> void:
	_space = clampi(selection - 1, 0, _items.size() - 1)
	if _space < _topics.size() and not _topics[_space].visible:
		_topics[space].show()
	first()

func setup(game: Control) -> void:
	_focus = game.get_node("focus")
	_focus.setup_items(self)
	_focus.timing.select.connect(set_focus)

func set_transition(hud: CanvasLayer, topic: Control) -> void:
	hud.visibility_changed.connect(func():
		if hud.visible and topic.visible: topic.topic.focused = false
			#_grab_focus(0)
		Works.turn(_focus, hud.visible and topic.visible)
	)
	topic.visibility_changed.connect(func():
		if hud.visible and topic.visible: topic.topic.focused = false
			#_grab_focus(0)
		Works.turn(_focus, hud.visible and topic.visible)
	)
	for slider in grabbed:
		slider.hold_focus.connect(func(status):
			Works.turn(_focus, status and hud.visible and topic.visible)
		)
"""



extends FocusedItems

func _ready() -> void:
	var game: MarginContainer = get_parent() 
	var xp: VBoxContainer = game.get_node("experience")
	_topics.push_back(xp.sound.options.get_parent())
	_topics.push_back(xp.experience.options.get_parent())
	_topics.push_back(xp.interface.options.get_parent())
	_topics.push_back(xp.stats)
	_items.push_back(xp.sound.options.get_items(self))
	_items.push_back(xp.experience.options.get_items())
	_items.push_back(xp.interface.options.get_items())
	_items.push_back(xp.stats.get_items())
	setup(game)



extends FocusedItems

func _ready() -> void:
	var controls: MarginContainer = get_parent() 
	var management: VBoxContainer = controls.get_node("management")
	_topics.push_back(management.mouse.options.get_parent())
	_topics.push_back(management.keyboard.options.get_parent())
	_topics.push_back(management.gamepad.options.get_parent())
	_items.push_back(management.mouse.options.get_items(self))
	_items.push_back(management.keyboard.options.get_items())
	_items.push_back(management.gamepad.options.get_items())
	setup(controls)



extends TopicFooter

@onready var controls: HBoxContainer = $margin/controls
@onready var caption: Label = $margin/caption

func set_controls(focus: bool) -> void:
	controls.visible = !focus
	caption.visible = focus



extends Button

class_name TopicFooter

@onready var topic: VBoxContainer = get_parent()
@onready var header: Button = topic.get_node("../header")

const MASK: String = "%10s"

var _caption: String
var _title: String
var title: String:
	get: return _title
	set(value):
		_title = value
		text = value

func _ready() -> void: _caption = text

func _hide_topic() -> void:
	topic.hide()
	header.grab_focus()

func finish_input() -> void:
	text = _caption

func input_button(buttons: String, kind: String = "") -> void:
	text = buttons + " = "
	text += tr(title) if kind == "" else MASK % tr(kind) #kind





extends VBoxContainer

#@onready var header: Button = $header
@onready var options: HFlowContainer = $content/options
@onready var footer: Button = $content/footer

extends VBoxContainer

@onready var options: HFlowContainer = $content/options

func get_items() -> Array[Control]:
	return [$header]


extends HFlowContainer

@onready var music: HSlider = $music
@onready var sound: HSlider = $sound
@onready var interface: HSlider = $interface
@onready var system: Button = $system

func set_soundtrack_transition(settings: CanvasLayer, ost: CanvasLayer) -> void:
	system.pressed.connect(func(): settings.hide() ; ost.show())

func get_items(items: FocusedItems) -> Array[Control]:
	get_sound(items)
	return [music.submit, sound.submit, interface.submit, system]

func get_sound(items: FocusedItems) -> void:
	items.grabbed.push_back(music)
	items.grabbed.push_back(sound)
	items.grabbed.push_back(interface)
	var footer: Button = get_node("../footer")
	for slider in items.grabbed:
		slider.hold_focus.connect(footer.set_controls)
	music.set_neighbor("../../../header", sound.get_neighbor())
	sound.set_neighbor(music.get_neighbor(), interface.get_neighbor())
	interface.set_neighbor(sound.get_neighbor(), "../system")
	system.focus_neighbor_left = interface.get_neighbor()


extends HFlowContainer

func get_items() -> Array[Control]:
	return [$language, $fullscreen, $counters, $health, $influence, $damage, $adaptive]


extends HFlowContainer

func get_items() -> Array[Control]:
	return [$narrative, $emotions]





extends HBoxContainer

@onready var enter: Button = $enter
@onready var collapse: Button = $collapse

var nodes: Array[Button]

func connect_collapsing(options: Array, t: Node) -> void:
	nodes = []
	for i in options: nodes.push_back(t.of(i))
	collapse.pressed.connect(toggle)
	enter.pressed.connect(func(): t.set_aggregate(nodes))

func toggle() -> void:
	var state: bool = !nodes.front().visible
	for b in nodes: b.visible = state # print("B NAME: ", b.name, " - STATE: ", b.visible)


extends HFlowContainer

func get_items() -> Array[Control]:
	return [$preset, $movement, $inventory, $targeting,
		$ability, $ab, $xy, $abxy, $preview]


extends HFlowContainer

func get_items() -> Array[Control]:
	return [$preset, $forward, $backward, $left, $right,
		$hands, $legs, $action_one, $action_two, $team,
		$group, $heal, $refresh, $analyze, $information,
		$settings, $main_menu, $soundtrack, $checkpoint,
		$fast_save, $fast_load, $export_progress,
		$import_progress, $fullscreen, $photo_mode]



extends HFlowContainer

@onready var sensitivity: HSlider = $sensitivity
@onready var hands: Button = $hands

func get_items(items: FocusedItems) -> Array[Control]:
	get_mouse(items)
	return [sensitivity.submit, $hands, $legs, $combo,
		$heal, $refresh, $set_skill, $use_skill,
		$set_inventory, $use_inventory, $help]

func get_mouse(items: FocusedItems) -> void:
	items.grabbed.push_back(sensitivity)
	var footer: Button = get_node("../footer")
	for slider in items.grabbed:
		slider.hold_focus.connect(footer.set_controls)
	sensitivity.set_neighbor("../../../header", "../hands")
	hands.focus_neighbor_left = sensitivity.get_neighbor()





extends VBoxContainer

@onready var mouse: VBoxContainer = $mouse
@onready var keyboard: VBoxContainer = $keyboard
@onready var gamepad: VBoxContainer = $gamepad
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [mouse.get_node("header"), gamepad.get_node("header"),
		keyboard.get_node("header"), keyboard.get_node("header"),
		mouse.options.sensitivity.submit, gamepad.options.get_node("preview")]




class_name FocusedSlider extends HSlider

""" MUSIC
@export_range (0, 100, 1) var default_volume: float = 50
@export var bus_name: String = "Master"

const FILE: String = "user://settings.json"

var bus_index: int

# Sound Slider Focus

func _ready() -> void:
	super._ready()
	print("BUS: ", AudioServer.get_bus_name(0))
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	var json: Dictionary = Vault.get_json(FILE, func(s): pass)
	if json != Def.DICT:
		default_volume = json.music
	_init()

func _init() -> void:
	value = default_volume
	_set_value(default_volume)

func _set_value(next: float) -> void:
	var db: float = linear_to_db(next / max_value)
	AudioServer.set_bus_volume_db(bus_index, db)
	
func _on_value_changed(value_to_change: float) -> void:
	_set_value(value_to_change)
	Vault.set_json(FILE, { "music": value_to_change })
"""


"""
signal hold_focus(status: bool)

@export var text: String = ""

@onready var submit: Button = $form/state/manual
@onready var caption: Label = $form/caption
@onready var manual: Node = $manual

var _manual: bool = false
var released: bool:
	get: return not _manual

func _ready() -> void:
	caption.text = text
	value_changed.connect(func(v: int):
		submit.text = str(v)#str(v, "%")
		if v == max_value:
			add_theme_icon_override("grabber", PreloadBus.grabber)
		else:
			add_theme_icon_override("grabber", null)
	)

func get_root() -> String: return "../../../../../../"

func get_neighbor() -> String:
	return "../" + name + "/margin/music/volume/state/info/manual"

func set_neighbor(left: String, right: String) -> void:
	var root: String = get_root()
	submit.focus_neighbor_left = root + left
	submit.focus_neighbor_right = root + right

func focus() -> void: manual.grab_focus()

func set_to(next: int) -> void:
	value = next
	value_changed.emit(value)

func safe_set(next: int) -> void:
	set_to(clampi(next, int(min_value), int(max_value)))

func append(tick: int) -> void:
	safe_set(int(value) + tick)

func focus_manual() -> void:
	set_manual(true)
	submit.release_focus()

func set_manual(next: bool) -> void:
	_manual = next
	Works.turn(manual, _manual)
	hold_focus.emit(!next)

func check_actions(_event: InputEvent) -> void:
	var actions: Array[String] = ["ui_cancel", "ui_accept", "list_right",
		"list_left", "list_up", "list_down", "ui_focus_next", "ui_focus_prev"]
	var i: int = actions.size() - 1
	var minimum: int = -1
	while i > minimum and not Input.is_action_just_pressed(actions[i]):
		i -= 1
	if i > minimum:
		set_manual(false)
		match actions[i]:
			"ui_accept": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_next": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_prev": submit.find_prev_valid_focus().grab_focus()
			_: submit.grab_focus()

func _input(event: InputEvent) -> void:
	if not _manual: return
	if event is InputEventMouseButton:
		set_manual(false)
	else:
		check_actions(event)




extends Node

@onready var loudness: HSlider = get_parent()
@onready var focus: Node = $focus
#@onready var timer: Timer = $timer
#@onready var timing: ActionTimer = $action

enum { TICK = 1, CLOCK = 10, MIN = 0, MAX = 100 }

var _value: String = ""
var _freeze: float = 0

func _reset() -> void: _value = ""

func _ready() -> void:
	focus.setup_items(self)
	focus.timing.MAX = 1000
	focus.timing.preview.connect(set_preview)
	focus.gamepad.special = true
	focus.timing.finish.wait_time = 1
	#focus.timing.action.period = 0.15

func first() -> void: loudness.set_to(MIN)
func last() -> void: loudness.set_to(MAX)

func set_space(point: float, system: float) -> void:
	var proportion: float = (point / system) * MAX
	loudness.safe_set(proportion)

func set_preview(value: int) -> void:
	loudness.safe_set(value)

func set_slider_value() -> void:
	var tick: float = Input.get_axis("ui_left", "ui_right")
	var clock: float = Input.get_axis("ui_down", "ui_up")
	if clock != 0 or tick != 0:
		loudness.append(clock * CLOCK + tick * TICK)
		_freeze = 0.05

func _physics_process(delta: float) -> void:
	if _freeze > 0:
		_freeze -= delta
	else:
		set_slider_value()
"""


extends Node

@onready var controls: Node = $controls
@onready var experience: Node = $experience




extends Node

var listen: bool = false
var repeat: bool = false





extends Node

enum { OFF, ON, BOSS, FOE }

var s: Node
var control: int: set = sets
var boss: Array[String] = []

func sets(value: int) -> void: pass

func alive(hp: int) -> bool: return 0 < hp
func has_card() -> bool: return s.get_value(s.CARD) != OFF
func fixate_card(hp: int, title: String) -> bool:
	match s.get_value(s.CARD): 
		BOSS: return alive(hp) and title in boss
		FOE: return alive(hp)
	return false

func prefers(size: int) -> bool:
	var state: int = s.get_value(s.COMBO)
	if state == OFF: return false
	if state == ON: return true
	return size == (state + 1)


extends Node

# @onready var sound: Node = $sound
@onready var game: Node = $game
@onready var interface: Node = $interface
@onready var store: Node = $store



extends Node

@onready var vendor: Node = $vendor
@onready var ost: Node = $ost
@onready var logic: Node = $logic
@onready var combo: Node = $combo


extends Node

signal update_logic_order(vendor: Node)

@onready var buttons: Node = $buttons

var vendor: bool: set = set_vendor
var reorder: bool: set = set_reorder
var order_a: bool: set = set_order_a
var order_x: bool: set = set_order_x
var press: bool = false

func update() -> void: update_logic_order.emit(self.buttons)
func set_prop(prop: String, value: bool) -> void: buttons.set(prop, value) ; update()

func set_vendor(value: bool) -> void:
	buttons.vendor = value
	if value:
		buttons.order_a = value
		buttons.order_x = value
	update()

func set_reorder(value: bool) -> void: set_prop("reorder", value)
func set_order_a(value: bool) -> void: set_prop("order_a", value)
func set_order_x(value: bool) -> void: set_prop("order_x", value)



extends Node

enum { A = JOY_BUTTON_A, B = JOY_BUTTON_B, X = JOY_BUTTON_X, Y = JOY_BUTTON_Y }

var vendor: bool = false
var reorder: bool = false
var order_a: bool = false
var order_x: bool = true

func result(button: Vector2i, ord: bool) -> int: return button.x if ord else button.y
func branch(group: Vector2i, a: int, ord: bool) -> int: return result(group, ord) if reorder else a
func gets(home: Vector2i, verge: Vector2i, x: bool, y: bool) -> int:
	if order_a: return branch(Vector2i(home.x, home.y), verge.x, order_x)
	return branch(Vector2i(home.y, home.x), verge.y, order_x)

const S: Rect2i = Rect2i(Vector2i(A, B), Vector2i(X, Y))
const R: Rect2i = Rect2i(Vector2i(B, A), Vector2i(Y, X))

func order(code: int) -> int:
	match code:
		JOY_BUTTON_A: return gets(R.size, R.position, order_a, order_x)
		JOY_BUTTON_B: return gets(S.size, S.position, order_a, order_x)
		JOY_BUTTON_X: return gets(R.position, R.size, order_x, order_a)
		JOY_BUTTON_Y: return gets(S.position, S.size, order_x, order_a)
	return code



extends Node

var t: Node

var genre: bool = false
var screen: bool: set = set_screen

func _screen(value: bool, w) -> DisplayServer.WindowMode:
	return w.WindowMode.WINDOW_MODE_WINDOWED if value else w.WindowMode.WINDOW_MODE_FULLSCREEN

func set_screen(value: bool) -> void:
	DisplayServer.window_set_mode(_screen(value, DisplayServer))




extends Node

enum { M = 0, UI = 1 }

var player: bool: set = set_player
var interface: int: set = set_interface
var items: int: set = set_items
var pplayer: IPreset = IPreset.new()
var pinterface: IPreset = IPreset.new()

func set_narrative(op: HFlowContainer, main: VBoxContainer) -> void:
	pplayer.s.p.p("visible").t()
	pplayer.add(op, "help", main.preview.help.hints)
	pplayer.add(op, "narrative", main.preview.chats.list.temp.chat)
	pplayer.add(op, "emotions", main.topic.space.options.chat.margin)
	pplayer.link()

func set_visual(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	pinterface.masks(pinterface.p.s.interface()).s.p.p("visible").t()
	pinterface.add(op, "aura", main.status.sticker.hp)
	pinterface.add(op, "resource", main.topic.status.preset.sets.ap)
	pinterface.s.p.p("control").t()
	pinterface.add(op, "damage", main.status.sticker.hp)
	pinterface.add(op, "options", main.status.sticker.hp)
	pinterface.p.p("items").s()
	pinterface.add(op, ["items", "itadaptive", "itstatus", "itfixed"], work) # logic)
	pinterface.p.p("control")
	pinterface.add(op, ["card", "coff", "cadaptive", "cboss", "cfoe"], work) # combo
	pinterface.link()

func set_player(value: bool) -> void: pplayer.switch(value)
func set_interface(value: int) -> void: pinterface.select(value)

func set_items(value: int) -> void:
	pass



extends Node

signal update()

const AUTO: String = "auto"

var available: Array[String] = ["en", "ru"]
var language: String = AUTO # Load here language from the user settings file

func sync() -> void: update.emit()

func set_auto() -> void: _set_locale(AUTO)

func set_language(next: int) -> void: _set_locale(available[next])

func _set_locale(next: String) -> void:
	language = next
	update_locale()

func update_locale() -> void:
	var prefer: String = OS.get_locale_language()
	if language != AUTO: prefer = language
	TranslationServer.set_locale(prefer)
	sync()



extends Node

@onready var language: Node = $language
@onready var logic: Node = $logic


class_name IPreset extends Node

var mask: Array = Def.ARRAY
var preset: Array = []
var s: Node

func masks(value: Array) -> IPreset: mask = value ; return self

func add(op: HFlowContainer, title: Variant, ui: Control) -> void:
	preset.push_back(s.get(s.p.c).model(op, title, ui, s.p.d))

func bit(value: int) -> Variant:
	return Def.DICT if mask == Def.ARRAY else mask[value]

func set_toggle(value: Variant, ref: Dictionary) -> void:
	ref.ui.set(ref.prop, value)
	s.t.show_text(ref, value)
	s.t.set_value(ref.bit)

func set_section(value: Variant, ref: Dictionary) -> void:
	ref.ui.set(ref.prop.prop, value)
	s.s.show_text(ref, value)
	s.s.set_value(ref.prop.bit)

func switch(value: bool) -> void: select(value)
func select(value: int) -> void:
	var m: Dictionary = bit(value)
	for i in preset:
		var r: int = value
		var b: int = i.prop.bit
		if m.has(b): r = m[b]
		if i.has("ON"):
			set_toggle(r, i)
		else:
			set_section(r, i)

func link() -> void:
	for i in preset: s.get("t" if i.has("ON") else "s").tap(i)



extends RefCounted

class_name IPresetBuilder

var _t: Dictionary = {}
var c: String = "t"
var d: Dictionary:
	get: return _t.duplicate()

func p(prop: String = "control") -> IPresetBuilder:
	_t.prop = prop ; return self

func n(node: String = "status") -> IPresetBuilder:
	_t.node = node ; return self

func t(on: String = "SON", off: String = "SOF") -> IPresetBuilder:
	_t.ON = on; _t.OFF = off ; c = "t" ; return self

func s(deep: bool = false) -> IPresetBuilder:
	_t.deep = deep ; c = "s" ; return self



extends Node

enum { DIFFICULTY, LANGUAGE, INTERFACE, ITEMS, CARD, COMBO }
enum { MASK = 0x02, MASK2 = 0x03 }

var settings: int = 0
var mask2: Array[int] = [DIFFICULTY]
var compat: Dictionary = { DIFFICULTY: [0, 2] }

func zeros(a: int, no: int) -> int: return a << no
func whole(a: int, no: int) -> int: return a >> no
func digit(no: int) -> int: return no * MASK

static func bit(no: int) -> int: return 2 ** no
static func is_bit(value: int, index: int) -> bool:
	var dig: int = bit(index)
	return value & dig == dig

func _get_exact_value(no: int) -> int: return get_mask(no, _value_behind)
func _value_behind(no: int) -> int: return settings & Works.bit(no)

func determine_mask(no: int) -> int:
	return MASK2 if no in mask2 else MASK

func get_mask(no: int, type: Callable = Works.bit) -> int:
	var value: int = 0
	var from: int = digit(no)
	var to: int = from + determine_mask(no)
	for i in range(from, to): value += type.call(i)
	return value

func get_value(no: int) -> int: return whole(_get_exact_value(no), digit(no))
func set_value(no: int, next: int) -> void: settings = settings & ~get_mask(no) | zeros(next, digit(no))

func option(op: HFlowContainer, title: Array, options: Array) -> void:
	for i in title: options.push_back(op.get_node(i))

func set_options(op: HFlowContainer, prop: Dictionary) -> void:
	if prop.has("deep") and prop.deep:
		for i in prop.title: prop.options += op.get_node(i).get_children()
		prop.section = []
		option(op, prop.title, prop.section)
	else:
		option(op, prop.title, prop.options)
		prop.section = prop.options

func model(op: HFlowContainer, title: Array, ui: Variant, prop: Dictionary) -> Dictionary:
	var caption: String = title.pop_front()
	prop.op = op
	prop.bit = get(caption.to_upper())
	prop.title = title
	prop.toggle = op.get_node(caption)
	prop.status = prop.toggle.get_node(prop.node)
	prop.options = []
	prop.ui = ui
	set_options(op, prop)
	return prop

func show_text(op: Dictionary, key: int) -> void:
	op.status.text = op.options[key].text

func select_show(toggle: Button, op: Dictionary) -> void:
	toggle.pressed.connect(func():
		if len(op.section) == 2:
			var state: bool = !bool(get_value(op.bit))
			set_bit_value(int(state), op.bit, op)
		else:
			var state: bool = !op.section.front().visible
			for i in op.section: i.visible = state)

func set_bit_value(i: int, bit: int, op: Dictionary) -> void:
	set_value(bit, i)
	var prop: String 
	if (op.prop is Dictionary):
		prop = op.prop.prop
	else:
		prop = op.prop
	op.ui.set(prop, i) # visible
	show_text(op, i)

func select_options(op: Dictionary, bit: int) -> void:
	show_text(op, get_value(bit))
	print("select_options - ")
	for i in len(op.options): # print(op.options[i].name)
		op.options[i].pressed.connect(func(): set_bit_value(i, bit, op))

func tap(op: Dictionary) -> void:
	select_show(op.toggle, op)
	select_options(op, op.bit)

func interface() -> Array[Dictionary]:
	return [
		{ ITEMS: 0, CARD: 0 },
		{ ITEMS: 0, CARD: 1 },
		{ ITEMS: 1, CARD: 2 },
		{ ITEMS: 2, CARD: 3 }
	]




extends Node

@onready var t: Node = $toggles
@onready var s: Node = $sections

var p: IPresetBuilder = IPresetBuilder.new()

func tap(op: HFlowContainer, title: String, ui: Variant, prop: Dictionary) -> void:
	t.tap(t.model(op, title, ui, prop))

func select(op: HFlowContainer, title: Array, ui: Variant, prop: Dictionary) -> void:
	s.tap(s.model(op, title, ui, prop))

func sets(op: HFlowContainer, vendor: Node, opts: Array) -> void:
	for i in opts: tap(op, i[0], vendor, p.p(i[0]).t(i[1], i[2]).d)

func interface() -> Array:
	var a: Array = t.interface()
	var b: Array = s.interface()
	for i in len(a): a[i].assign(b[i])
	return a


extends Node

enum { LISTEN, REPEAT, PLAYER, GENRE, NARRATIVE, QUOTES, HELP, EMOTIONS, OPTIONS,
	SCREEN, AURA, RESOURCE, DAMAGE, VENDOR, REORDER, ORDER_A, ORDER_X, PRESS }

@onready var bits: Node = $bits

func get_value(no: int) -> bool: return bits.get_value(no)
func set_value(no: int, next: bool) -> void: bits.set_value(no, next)
func switch(no: int, next: int) -> bool: return bits.switch(no, next)

func toggle(next: int, op: Dictionary) -> void:
	var state: bool = switch(next, !get_value(next))
	op.ui.set(op.prop, state) # visible
	show_text(op, state)

func toggles(next: int, ui: Array) -> void:
	var state: bool = switch(next, !get_value(next))
	for i in ui: i.visible = state

func show_text(op: Dictionary, state: bool) -> void:
	op.status.text = op.ON if state else op.OFF

func tap(op: Dictionary) -> void:
	show_text(op, op.bit)
	op.toggle.pressed.connect(func(): toggle(op.bit, op))

func model(op: HFlowContainer, title: String, ui: Variant, prop: Dictionary) -> Dictionary:
	prop.bit = get(title.to_upper())
	prop.toggle = op.get_node(title)
	prop.status = prop.toggle.get_node(prop.node)
	prop.ui = ui
	return prop

func interface() -> Array[Dictionary]:
	return [
		{ AURA: false, RESOURCE: false, DAMAGE: false, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: false, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: true, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: true, OPTIONS: true },
	]





"""

extends ActionsControl

func new_controls(act: String) -> void:
	var event := InputEventKey.new()
	event.keycode = actions[act]
	event.pressed = true
	_set_event(act, event)

func set_mask() -> ActionsControl:
	return super.set_mask().m(
		"MT", [[ACT.UP, ACT.LEFT, ACT.DOWN, ACT.RIGHT], [ACT.LEGS]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.LEFT): [KEY_LEFT], a(ACT.UP): [KEY_UP], a(ACT.RIGHT): [KEY_RIGHT],
		a(ACT.DOWN): [KEY_DOWN], a(ACT.HANDS): [KEY_Z, KEY_E], a(ACT.LEGS): [KEY_X, KEY_Q],
		a(ACT.SKILL_ONE): [KEY_C], a(ACT.SKILL_TWO): [KEY_V], a(ACT.FIRE): [KEY_F],
		a(ACT.VIEW_UP): [KEY_MINUS], a(ACT.VIEW_DOWN): [KEY_PLUS],
		a(ACT.INVENTORY_UP): [KEY_TAB, KEY_2], a(ACT.GROUP_TEAM): [KEY_T], 
		a(ACT.INVENTORY_DOWN): [KEY_TAB, KEY_3], a(ACT.GROUP_DEPLOY): [KEY_G],
		a(ACT.SAVES): [KEY_F2], a(ACT.SETTINGS): [KEY_F3],
		a(ACT.MAIN_MENU): [KEY_F4], a(ACT.OST_SYSTEM): [KEY_F5],
		a(ACT.CHECKPOINT): [KEY_F6], a(ACT.FAST_SAVE): [KEY_F7],
		a(ACT.FAST_LOAD): [KEY_F8], a(ACT.FULLSCREEN): [KEY_F11],
		a(ACT.PHOTOMODE): [KEY_F12],
		a(ACT.PANEL_LEFT_TOGGLE): [KEY_TAB, KEY_1],
		a(ACT.PANEL_RIGHT_TOGGLE): [KEY_TAB, KEY_4],
	}
"""



extends ActionsControl

var device: Dictionary

func new_controls(act: String) -> void:
	var event := InputEventJoypadButton.new() # InputEventJoypadMotion
	event.button_index = actions[act]
	event.pressed = true
	_set_event(act, event)

func search_sticks(key: int) -> void:
	for k in keys.sticks:
		if key in keys.sticks[k]:
			word = k
			break

func translate_word(key: int) -> bool:
	if super.translate_word(key):
		if keys.pad.has(key) and keys.pad.has(device.type):
			word = keys.pad[device.type][word]
	else:
		search_sticks(key)
	return true

func set_mask() -> ActionsControl:
	return super.set_mask().m("MT", [[ACT.MOVEMENT], [ACT.LEGS]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.MOVEMENT): [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
		a(ACT.AIMING): [JOY_AXIS_TRIGGER_LEFT, JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y],
		a(ACT.HANDS): [JOY_BUTTON_A], a(ACT.LEGS): [JOY_BUTTON_B],
		a(ACT.SKILL_ONE): [JOY_BUTTON_X], a(ACT.SKILL_TWO): [JOY_BUTTON_Y],
		a(ACT.FIRE): [JOY_AXIS_TRIGGER_RIGHT],
		a(ACT.VIEW_UP): [JOY_AXIS_TRIGGER_RIGHT, JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y],
		a(ACT.VIEW_DOWN): [KEY_PLUS],
		a(ACT.INVENTORY_UP): [JOY_AXIS_TRIGGER_LEFT, JOY_BUTTON_LEFT_SHOULDER],
		a(ACT.GROUP_TEAM): [JOY_BUTTON_LEFT_SHOULDER],
		a(ACT.INVENTORY_DOWN): [JOY_AXIS_TRIGGER_RIGHT, JOY_BUTTON_RIGHT_SHOULDER],
		a(ACT.GROUP_DEPLOY): [JOY_BUTTON_RIGHT_SHOULDER],
		a(ACT.PANEL_LEFT_TOGGLE): [JOY_BUTTON_DPAD_LEFT],
		a(ACT.PANEL_RIGHT_TOGGLE): [JOY_BUTTON_DPAD_RIGHT]
	}



extends Node

signal hints()

var type: String = "keyboard"
var keys: Node
var selected: Node:
	get: return keys[type]

@onready var gamepad: Node = $gamepad

func sync_hints(event: InputEvent) -> String:
	if gamepad.determine(event): return "gamepad"
	elif event is InputEventMouseButton: return "mouse"
	return "keyboard"

func _input(event: InputEvent) -> void:
	var prev: String = type
	type = sync_hints(event)
	if type != prev: hints.emit()



extends Node

@onready var type: Node = $type

var device: Dictionary = {
	"name": get_first_gamepad_name(),
	"type": KeyAndButtonEscapes.PAD.XBOX
}

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func get_first_gamepad_name() -> String:
	return Input.get_joy_name(0).to_lower()

func coop() -> void: pass # get_connected_joypads()
func determine(event: InputEvent) -> bool:
	if not (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return false
		
	device.name = get_first_gamepad_name()
	if device.name != "":
		device.type = type.get_gamepad_type()
		return true
	return false



extends Node

var types: Array[Array] = [["ps"], ["xbox"], ["xinput", "nintendo", "stk"]]
var found: bool = false

func determine_model(model: Array, device: String) -> void:
	var no: int = model.size()
	while no > 0 and not found:
		no -= 1 # print(size.x, ", ", size.y, ", ", type[size.x][size.y])
		found = device.contains(model[no])

func determine_type(type: int, device: String) -> int:
	while type > 0 and not found:
		type -= 1 # print("Device: ", device)
		determine_model(types[type], device)
	return type

func get_gamepad_type(device: String) -> KeyAndButtonEscapes.PAD:
	found = false
	return (determine_type(types.size(), device)
		if found else KeyAndButtonEscapes.PAD.XBOX)



extends Node

class_name KeyAndButtonEscapes

@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _ready() -> void:
	for i in [mouse, keyboard, gamepad]:
		i.keys = self
		i.defaults = keyboard

enum PAD { XBOX = 0, PS = 1, NINTENDO = 2 }

var pad: Dictionary = {
	PAD.PS: {
		"BTX": "BRT", "BTY": "BTR", "BTA": "BCR", "BTB": "BCL",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	},
	PAD.NINTENDO: {
		"BTX": "BTY", "BTY": "BTX", "BTA": "BTB", "BTB": "BTA",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	}
}

var sticks: Dictionary = {
	"BLS": [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
	"BRS": [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
}

var mouses: Dictionary = {
	MOUSE_BUTTON_LEFT: "LMB", MOUSE_BUTTON_RIGHT: "RMB", MOUSE_BUTTON_WHEEL_DOWN: "WDN",
	MOUSE_BUTTON_WHEEL_UP: "WUP", MOUSE_BUTTON_WHEEL_LEFT: "WLT", MOUSE_BUTTON_WHEEL_RIGHT: "WRT"
}

var escapes: Dictionary = {
	KEY_LEFT: "KAL", KEY_RIGHT: "KAR", KEY_DOWN: "KAD", KEY_UP: "KAU",
	KEY_SHIFT: "KSH", KEY_BACKSPACE: "BSP", KEY_TAB: "TAB", KEY_NUMLOCK: "KNL",
	KEY_SPACE: "KSP", KEY_ESCAPE: "KEC", KEY_INSERT: "KIN", KEY_DELETE: "KDL",
	KEY_PRINT: "KPS", KEY_CAPSLOCK: "KCL", KEY_PAUSE: "KPB", KEY_PAGEUP: "KPU",
	KEY_PAGEDOWN: "KPD", KEY_HOME: "KHM", KEY_END: "KED", KEY_KP_PERIOD: "KGM",
	KEY_KP_DIVIDE: "KGD", KEY_KP_ADD: "KGA", KEY_KP_SUBTRACT: "KGS",
	JOY_BUTTON_DPAD_LEFT: "KAL", JOY_BUTTON_DPAD_UP: "KAU",
	JOY_BUTTON_DPAD_RIGHT: "KAR", JOY_BUTTON_DPAD_DOWN: "KAD",
	JOY_BUTTON_A: "BTA", JOY_BUTTON_B: "BTB", JOY_BUTTON_X: "BTX", JOY_BUTTON_Y: "BTY",
	JOY_AXIS_TRIGGER_LEFT: "BLT", JOY_AXIS_TRIGGER_RIGHT: "BRT",
	JOY_BUTTON_LEFT_SHOULDER: "BLB", JOY_BUTTON_RIGHT_SHOULDER: "BRB",
}


"""
extends ActionsControl

func get_escapes() -> Dictionary: return keys.mouses

func new_controls(act: String) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = actions[act]
	event.pressed = true
	_set_event(act, event)

func set_mask() -> ActionsControl:
	return m("CF", [[ACT.UI_LMB]]).m("AY", [[ACT.UI_LMB]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.HANDS): [MOUSE_BUTTON_LEFT],
		a(ACT.LEGS): [MOUSE_BUTTON_RIGHT],
		a(ACT.SKILL_ONE): [MOUSE_BUTTON_WHEEL_DOWN],
		a(ACT.SKILL_TWO): [MOUSE_BUTTON_WHEEL_UP],
		a(ACT.MOVEMENT): [MOUSE_BUTTON_LEFT],
		a(ACT.FIRE): [MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_LEFT],
		a(ACT.UI_LMB): [MOUSE_BUTTON_LEFT]
		#, # a.GD: MOUSE_BUTTON_LEFT, # a.GT: MOUSE_BUTTON_LEFT,
	}
"""



class_name ActionsControl extends Node

var keys: Node
var defaults: Node
var word: String
var actions: Dictionary
var escapes: Dictionary: get = get_escapes

func get_escapes() -> Dictionary: return keys.escapes
func _set_event(act: String, event: InputEvent) -> void:
	InputMap.action_erase_event(act, event)
	InputMap.action_add_event(act, event)

func set_action(caption: String, keys: Array) -> void:
	actions[caption] = keys

func a(no: int) -> String: return _act[no]

func translate_word(key: int) -> bool:
	if not escapes.has(key):
		word = OS.get_keycode_string(key)
		return false
	word = tr("S" + escapes[key])
	return true

func translate_sentence(act: Array, s: bool = false) -> Array[String]:
	var sentence: Array[String] = []
	for i in act:
		if i == Def.INT:
			word = "_"
		else:
			translate_word(i if s else actions[a(i)])
		sentence.append(word)
	return sentence

func translate(acts: Array, sep: String, s: bool = false) -> Array[String]:
	var result: Array[String] = []
	for act in acts: result.append(sep.join(translate_sentence(act, s)))
	return result

func translate_alt(acts: Array) -> Array[String]: return translate_sentence(acts, true)
func translate_agg(acts: Array) -> Array[String]: return translate(acts, "", true)
func translate_all(acts: Array) -> Array[String]: return translate(acts, " + ", true)

func masked_translate(hint: String, sep: String) -> Array[String]:
	if mask.has(hint): return translate(mask[hint], sep)
	if defaults.has(hint): return defaults[hint]
	return Def.ARRAY

func masked_agg(hint: String) -> Array[String]: return masked_translate(hint, "")
func masked_all(hint: String) -> Array[String]: return masked_translate(hint, " + ")

enum ACT {
	MOVEMENT, LEFT, UP, RIGHT, DOWN, HANDS,
	LEGS, SKILL_ONE, SKILL_TWO, FIRE, VIEW_UP,
	VIEW_DOWN, INVENTORY_UP, INVENTORY_DOWN, GROUP_TEAM,
	GROUP_DEPLOY, QUICK_HEAL, QUICK_REFRESH, MAP,
	SAVES, SETTINGS, MAIN_MENU, OST_SYSTEM,
	CHECKPOINT, FAST_SAVE, FAST_LOAD, FULLSCREEN,
	PHOTOMODE, AIMING, PANEL_LEFT_TOGGLE, PANEL_RIGHT_TOGGLE,
	INVENTORY_TOGGLE, ABILITY_TOGGLE, EQUIPMENT_TOGGLE, PRIORITIES_TOGGLE,
	INVENTORY_SHOW, ABILITY_SHOW, EQUIPMENT_SHOW, PRIORITIES_SHOW,
	INVENTORY_HIDE, ABILITY_HIDE, EQUIPMENT_HIDE, PRIORITIES_HIDE,
	UI_LMB
}

const _act: Array[String] = [
	"movement", "left", "forward", "right", "backward", "action", "run", "skill_one",
	"skill_two", "fire", "view_left", "view_right", "inventory_up", "inventory_down",
	"select", "deploy", "quick_heal", "quick_refresh", "map", "saves", "settings",
	"main_menu", "ost_system", "checkpoint", "fast_save", "fast_load", "fullscreen",
	"photomode", "aiming", "panel_left_toggle", "panel_right_toggle",
	"inventory_toggle", "ability_toggle", "equipment_toggle", "priorities_toggle",
	"inventory_show", "ability_show", "equipment_show", "priorities_show",
	"inventory_hide", "ability_hide", "equipment_hide", "priorities_hide", "ui_lmb"
]

func m(type: String, value: Array) -> ActionsControl:
	mask[type] = value
	return self

func set_mask() -> ActionsControl:
	return m("СM", [[ACT.INVENTORY_TOGGLE], [ACT.HANDS]]
	).m("RM", [[ACT.GROUP_TEAM]]).m(
		"RG", [[ACT.GROUP_DEPLOY], [ACT.GROUP_DEPLOY]]
	).m("AM", [[ACT.AIMING], [ACT.MOVEMENT]]).m(
		"LG", [
		[ACT.INVENTORY_SHOW], [ACT.INVENTORY_HIDE],
		[ACT.EQUIPMENT_SHOW], [ACT.EQUIPMENT_HIDE],
		[ACT.PRIORITIES_SHOW], [ACT.PRIORITIES_HIDE],
		[ACT.ABILITY_SHOW], [ACT.ABILITY_HIDE],
	]).m("CF", [[ACT.HANDS]]).m("AY", [[ACT.HANDS]])

func _ready() -> void: set_mask()

var mask: Dictionary = {
	"MB": [[ACT.HANDS]],
	"AA": [[ACT.HANDS]],
	"AF": [[ACT.SKILL_ONE]],
	"AH": [[ACT.SKILL_TWO]],
	"AW": [[ACT.SKILL_ONE]],
	"AT": [[ACT.SKILL_TWO]],
	"CF": [[ACT.HANDS]],
	"SR": [[ACT.LEGS], [ACT.LEGS]],
}




extends Node

@onready var keys: Node = $keys
@onready var determine: Node = $determine
@onready var manage: Node = $manage




extends Node

@onready var mode: Node = $mode
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _input(event: InputEvent) -> void:
	if mode.type.listen():
		mode.manage(get(mode.device.named), event)


extends Node

var manage: Node

func c(e: InputEvent) -> int: return e.button_index

func add_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.pressed:
		manage.mode.input.append(c(event))
		manage.mode.input.enter()
	else:
		manage.mode.input.finish()

func hot(event: InputEvent) -> void: add_mouse(event)




extends Node

var input: Node

func c(e: InputEvent) -> int: return e.keycode

func delete(drop: Callable) -> void:
	if input.store.masked():
		input.delete_last()
	else:
		drop.call()

func complete(check: String) -> void:
	if input.store.get(check).call():
		input.stop_operating()
	else:
		input.finish()

func all(event: InputEvent) -> void:
	if input.locked or not input.got_hotkey(event, false):
		input.add() ; input.enter()

func add(event: InputEvent) -> void:
	if event.is_pressed() and not input.store.limit():
		input.start_enter()
		input.enter()

func add_key(code: int, check: Callable, count: String) -> Callable:
	return func(): if check.call(code): input.add_key(code, count) # print("INPUT A KEY!!")

func aggregate_next(code: int) -> Callable:
	return func(): input.enter_next(code)

func _form(check: String, next: Callable, drop: Callable) -> Dictionary:
	return { "add": next, "drop": drop, "check": check }

func alternate(event: InputEvent, key: String, count: String = "MAX", default: String = "nullify") -> Dictionary:
	return _form("is_mask", add_key(c(event), input.store.get(key), count), input.get(default))

func aggregate(event: InputEvent) -> Dictionary:
	return _form("undefined", aggregate_next(c(event)), input.clear_last)




extends Node

@onready var sequence: Node = $sequence

func one_key(event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		sequence.manage.mode.clear()
	else:
		sequence.manage.finish([event.keycode])

func add_keys(event: InputEvent, op: Dictionary) -> void:
	print("KEYCODE: ", event.keycode, " - Is: ", event.keycode == KEY_BACKSPACE)
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(op.defaulting)
		KEY_ESCAPE: sequence.clear_keys()
		KEY_ENTER: sequence.complete(op.check)
		_: op.add.call()

func _alt(state: bool, event: InputEvent, type: String, count: String = "MAX", default: String = "nullify") -> void:
	if state: add_keys(event, sequence.alternate(event, "key_" + type, count, default))

func _agg(state: bool, event: InputEvent) -> void:
	if state: add_keys(event, sequence.aggregate(event))

func _lock() -> bool:
	sequence.input.locked = true
	return true

func _all(event: InputEvent) -> void:
	if sequence.input.got_hotkey(event): return
	if sequence.input.hotkeys(event.keycode): return
	
	var state: bool = not sequence.input.store.present(event.keycode, true)
	_alt(state, event, "hold", "key_mask", "delete_last")

func alternate(event: InputEvent) -> void:
	_alt(sequence.input.store.unique(event), event, "alt")

func hot(event: InputEvent) -> void:
	if event.is_pressed():
		_alt(not sequence.input.store.present(event.keycode), event, "press")
	else:
		sequence.input.finish()

func aggregate(event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add(event)
		_: _agg(sequence.input.store.unique(event, true), event)

func all(event: InputEvent) -> void:
	match event.keycode:
		KEY_BACKSPACE: if event.is_pressed(): sequence.input.remove_last()
		KEY_COMMA: if event.is_pressed(): sequence.all(event)
		KEY_ENTER: pass
		_: _all(event)



extends Node

@onready var button: Node = $button

func c(e: InputEvent) -> int: return e.button_index

func one_key(_d, event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		button.finish(button.from_axis(event))
	else:
		button.finish([c(event)])

func hot(_d, event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		button.add_buttons(event.pressed, c(event))
	else:
		button.add_buttons(event.axis_value != 0, button.from_axis(event))
		
func aggregate(event: InputEvent) -> void:
	if event is InputEventJoypadMotion and button.all_axis(event): return
	if event.pressed: button.add_buttons(button.completed(), c(event))


extends Node

var manage: Node

enum { S = -1, E = 1, MAX = 4 }

func c(e: InputEvent) -> int: return e.axis

func completed() -> bool:
	return manage.next.size() < MAX

func finish(buttons: Array) -> void:
	manage.finish(buttons)

func add_buttons(state: bool, button: Variant) -> void:
	if state:
		manage.next.append(button)
	else:
		finish(manage.next)

func from_axis(event: InputEventJoypadMotion) -> Array:
	return [c(event), event.axis_value]

func add_ax(axis: int, value: int) -> Node:
	manage.next.append([axis, value])
	return self

func add_axs(x: int, y: int) -> void:
	add_ax(x, S).add_ax(y, S).add_ax(x, E).add_ax(y, E)

func auto_ax(event: InputEvent, ax: Array) -> void:
	for a in ax: if c(event) in ax:
		add_axs(a[0], a[1]); return

func all_axis(event: InputEvent) -> bool:
	manage.next.clear()
	auto_ax(event, [
		[JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
		[JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
	])
	manage.finish(manage.next)
	return true



extends Node

enum { MOUSE = 0, KEYBOARD = 1, GAMEPAD = 2 }

const names: Array[String] = ["mouse", "keyboard", "gamepad"]
const types: Array[int] = [MOUSE, KEYBOARD, GAMEPAD]

var device: int = KEYBOARD
var named: String:
	get: return names[device]

func set_as(machine: int) -> void: device = machine

func check(event: InputEvent) -> bool:
	match device:
		MOUSE: return not event is InputEventMouseButton and not event is InputEventMouseMotion
		GAMEPAD: return not event is InputEventMouseButton and not event is InputEventJoypadMotion
	return not event is InputEventKey



extends Node

var next: Array = []
var last: Variant:
	get: return next.back()
var agg: int:
	get: return next.size() - 1

enum { RESET = 0, SINGLE = 1, MAX = 3 } # SINGLE = 1, # const RESET: int = 0

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA, KEY_0, KEY_1, KEY_2,
		KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func nullify_agg() -> void: last.fill(Def.INT)
func nullify() -> void: sets(next, RESET, Def.INT)
func sets(element: Array, no: int, code: int) -> void: element[no] = code

func present(code: int, deep: bool = false) -> bool: return code in (last if deep else next)
func defined() -> bool: return not undefined()
func undefined() -> bool: return Def.INT in last
func is_mask() -> bool: return last == Def.INT

func remove() -> void: next.pop_back()
func clear() -> void: next.clear()
func shorten() -> void: last.clear()

func add_last(unit: Variant) -> void: last.push_back(unit)
func add_next(unit: Variant) -> void:
	next.push_back(unit)
	agg = next.size() - 1

func compare(to: int) -> bool: return next.size() == to
func empty() -> bool: return compare(RESET)
func limit() -> bool: return compare(MAX)
func masked() -> bool: return next.size() > SINGLE

func is_hard(code: bool) -> bool: return code in hardcoded()
func key_hold(code: int) -> bool: return not is_hard(code) or not empty()
func key_alt(_code: int) -> bool: return not limit()
func key_press(code: int) -> bool: return key_hold(code) and key_alt(code)

func unique(e: InputEvent, deep: bool = false) -> bool:
	return e.is_pressed() and not present(e.keycode, deep)

func append(unit: Variant, mode: Node) -> void:
	if mode.input.link.is_deep(unit): # and not empty():
		add_next(unit)
	elif mode.type.deep():
		add_last(unit)
	else:
		add_next(unit)




extends Node

@onready var store: Node = $store
@onready var link: Node = $link

var key_mask: int = 1
var locked: bool = false
var place: int:
	get: return min(get_place(store.last, Def.INT), key_mask - 1)
var MAX: int:
	get: return store.MAX

const SINGLE: int = 1

func get_place(s: Array, n: int) -> int: return s.size() - s.count(n)
func next_key(state: String, op: Callable) -> void:
	if store.get(state).call():
		op.call()

func start_enter() -> void: next_key("defined", add_mask)
func enter_next(code: int) -> void: next_key("undefined", link.store_keys(code))

func clear() -> void: store.clear() ; enter()
func stop_operating() -> void: store.clear(); link.clear()

func _remove_unit() -> void: if not store.masked(): store.remove()
func _remove_after_mask() -> void: if not store.empty(): store.remove()
func remove_last() -> void:
	_remove_unit() ; store.shorten() ; enter()
	locked = false

func nullify() -> void: store.nullify()
func delete_last() -> void:
	store.remove() ; clear_last() ; enter()

func agg(type: Node) -> int:
	print("GROUP PLACE: ", place)
	return place if type.aggregated_mask() else store.agg

func _remove_deep() -> void:
	if link.is_shallow(store.last):
		store.shorten()
	else:
		_remove_after_mask()

func nullify_group() -> void:
	store.nullify_agg() ; enter()

func clear_last() -> void:
	if key_mask == SINGLE:
		_remove_deep()
	else:
		nullify_group()

func lock(state: bool) -> bool:
	locked = state
	return true

func add_key(code: int, maximum: String) -> void:
	append(code) ; get("finish" if store.compare(get(maximum)) else "enter").call()

func append(unit: Variant) -> void: store.append(unit, link.mode)
func add() -> void: append([])
func add_mask() -> void: append(link.form(key_mask))

func enter() -> void: link.enter(store.next)
func finish() -> void: link.finish(store.next) ; stop_operating()
func interrupt() -> void: link.interrupt() ; stop_operating()

func hotkeys(code: int) -> bool:
	return not locked or store.is_hard(code) and lock(true)

func got_hotkey(event: InputEvent, state: bool = true) -> bool:
	return not event.is_pressed() and lock(state)

func mask(keys: int, type: Node) -> void:
	key_mask = keys
	match type.selected:
		type.AGG: add_mask() # if keys != SINGLE
		type.ALL: add()
	enter()


extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])
signal interrupt_input()

var option: String = ""
var mode: Node
var store: Node:
	get: return mode.input.store

func clear() -> void: mode.type.clear()
func interrupt() -> void:
	if option != "":
		interrupt_input.emit()

func form(count: int) -> Array:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Def.INT)
	return unit

func store_code(element: Array, code: int) -> void:
	store.sets(element, mode.input.place, code)

func store_next(code: int) -> void:
	store.sets(store, store.next, code)

func store_last(code: int) -> void:
	store_code(store.last, code)
	enter(store.next)

func enter(codes: Array, input: Signal = enter_keys) -> void:
	input.emit(mode.translate(codes))

func finish(codes: Array) -> void: enter(codes, finish_combo)

func is_deep(unit: Variant) -> bool: return unit is Array # not empty() and last is Array and not  - PUT before

func store_keys(code: int) -> Callable:
	return func():
		if is_deep(store.last):
			store_last(code)
		else:
			store_next(code)




extends Node

@onready var device: Node = $device
@onready var input: Node = $input
@onready var type: Node = $type

var keys: Node
var buttons: Node:
	get: return keys.get(device.named)
var aggregate: Array = Def.ARRAY

func select(caption: String, mask: int = input.DEFAULT) -> void:
	mask = type.mask(caption, mask)
	type.select(type.get(caption))
	input.mask(mask, type)

func footer_status(footer: Button, text: String) -> void:
	if aggregate == Def.ARRAY:
		footer.input_button(text)
	else:
		footer.input_button(text, aggregate[input.agg(type)].text)

func manage(machine: Node, event: InputEvent) -> void:
	if not device.check(event):
		type.manage(machine, event)

func translate(sequence: Array) -> Array:
	return type.translate(keys.get(device.named), sequence)

func interrupts(set_finish_title: Callable) -> void:
	input.link.interrupt_input.connect(set_finish_title)

func connects(enter: Callable, controls: Callable) -> void:
	input.link.enter_keys.connect(enter)
	input.link.finish_combo.connect(controls)

func _ready() -> void: input.link.mode = self




extends Node

signal start_input()
signal interrupt_input()

enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 }

var selected: int = NONE
var separator: String:
	get: return " + " if selected == HOT else ", "

func mask(caption: String, keys: int) -> int:
	if get(caption) == AGG and keys == KEY: return AGG
	if get(caption) in [HOT, ALT]: return KEY
	return keys

func listen() -> bool: return selected != NONE

func clear() -> void:
	selected = NONE
	interrupt_input.emit()

func select(value: int) -> void:
	selected = value
	start_input.emit()

func aggregated_mask() -> bool: return selected == AGG
func deep() -> bool: return selected in [AGG, ALL]

func manage(type: Node, event: InputEvent) -> void:
	match selected:
		KEY: type.one_key(event)
		ALT: type.alternate(event)
		HOT: type.hot(event)
		AGG: type.aggregate(event)
		ALL: type.all(event)

func translate(device: Node, sequence: Array) -> Array:
	match selected:
		AGG: return device.translate_agg(sequence)
		ALL: return device.translate_all(sequence)
	return device.translate_alt(sequence)




## SOUND

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
