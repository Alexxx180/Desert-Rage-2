extends CanvasLayer

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
