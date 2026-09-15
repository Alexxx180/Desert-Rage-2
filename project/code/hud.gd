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
var _pause: Control; var _game: Control; var _settings: Control; var _sound: Control; var _information: Control



var up_transit: ColorRect
var down_transit: ColorRect


func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		var last: bool = n.hud.logic.is_opened_last
		result = result and (not last)
	return not result

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



enum { IS_FULL }

var logs: PackedScene
var text: PackedStringArray = ["Полегче с этим."]

func add_log(caption: String) -> void:
	var line: Label = logs.instantiate()
	HUD.game.log.add_child(line)
	line.text = caption

func notify(type: int) -> void: add_log(text[type])


var main_transit: ColoreRect
var side_transit: ColoreRect
var transit_type: int = 0
enum { LADDER_DOWN, LADDER_UP, GATE_IN, GATE_OUT }

func gate_enter(from: Color, to: Color) -> void:
	main_transit.color = from
	main_transit.scale.y = 1.0
	create_tween().tween_property(main_transit, ^"color", to, 0.5)

func ladder_exit(main: ColorRect) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(main, ^"scale.y", 0.0, 0.5)
	tween.tween_callback(func(): main.hide())

func ladder_enter(main: ColorRect, side: ColorRect) -> void:
	var tween: Tween = create_tween(); main.scale.y = 0.0
	tween.tween_property(main, ^"scale.y", 1.0, 0.5)
	tween.tween_callback(func(): side.scale.y = 1.0; side.show(); main.hide())

func exit_transit() -> void:
	match type:
		GATE_OUT, GATE_IN:
			var tween: Tween = create_tween()
			tween.tween_property(main_transit, ^"color", Color.TRANSPARENT, 0.5)
			tween.tween_callback(func(): main_transit.hide())
		LADDER_DOWN: ladder_exit(side_transit)
		LADDER_UP: ladder_exit(main_transit)

const BLACK_TRANSPARENT: Color = Color(0, 0, 0, 255)

func entry_transit(type: int) -> void:
	main_transit.color = Color.BLACK
	match type:
		GATE_OUT:
			main_transit.color = Color.WHITE
			gate_enter(Color.TRANSPARENT, Color.WHITE)
		GATE_IN: gate_enter(BLACK_TRANSPARENT, Color.BLACK)
		LADDER_DOWN: ladder_enter(main_transit, side_transit)
		LADDER_UP: ladder_enter(side_transit, main_transit)

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

var who: PackedStringArray = ["RAY", "ROCK", "DID", "???"]
var face: PackedStringArray = ["look", "rage", "grin", "smile", "confirm",
	"tired", "but", "sign", "amaze", "respect", "anger", "play", "rain", "scare"]

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



func new_game() -> void:
	set_game()
	pass

func continue_game() -> void:
	set_game()
	pass

@onready var tree: SceneTree = get_tree()

func resume_game() -> void:
	tree.paused = false
	pause.hide()
	game.show()

func pause_game() -> void:
	if pause == null:
		pause = load(Def.pause).instantiate()
		add_child(pause)
		pause.get_node(^"options/resume").connect(resume_game)
		pause.get_node(^"options/saves").connect(enter_saves)
		pause.get_node(^"options/settings").connect(enter_settings)
		pause.get_node(^"options/main").connect(open_main_menu)
	tree.paused = true
	game.hide()
	pause.show()

func enter_pause() -> void:
	if saves != null: saves.hide()
	if settings != null: settings.hide()
	pause.show()

func enter_saves() -> void:
	if saves == null:
		saves = load(Def.saves).instantiate()
		add_child(saves)
		saves.back.connect(enter_pause)
		saves.sound.connect(sound_show)
	pause.hide()
	saves.show()

func enter_settings() -> void:
	if settings == null:
		settings = load(Def.settings).instantiate()
		add_child(settings)
		settings.back.connect(enter_pause)
		settings.sound.connect(sound_show)
	pause.hide()
	settings.show()

func open_main_menu() -> void:
	tree.load_scene(Def.main_menu)

var dialog_on: bool = false
var logs_on: bool = false
var help_on: bool = false

func set_game() -> void:
	if game == null:
		game = load(Def.game).instantiate()
		add_child(game)
		right = game.get_node(^"right")
		left = right.get_node(^"left")
		top = left.get_node(^"top")
		bottom = top.get_node(^"bottom")
		controls = bottom.get_node(^"controls")
		right_priorities = right.get_node(^"priorities")
		left_stats = left.get_node(^"stats")
		top_inventory = top.get_node(^"inventory") # PanelContainer
		bottom_ability = bottom.get_node(^"ability")
		fix_log = controls.get_node(^"controls/log")
		if dialog_on:
			talk_border = controls.get_node(^"dialog/talk/border")
			talk_image = controls.get_node(^"dialog/talk/border/image")
			dialogs = controls.get_node(^"dialog/talk")
		if logs_on: logs = controls.get_node(^"controls/logs")
		if help_on: help = controls.get_node(^"middle/help")


var game: Control; var pause: Control; var settings: Control; var information: Control; var sound: Control
var right: HSplitContainer; var left: HSplitContainer; var top: VSplitContainer; var bottom: VSplitContainer; var controls: MarginContainer
var right_priorities: PanelContainer; var left_stats: PanelContainer; var top_inventory: PanelContainer; var bottom_ability: PanelContainer

var fix_log: Label; var logs: RichTextLabel; var talk_border: PanelContainer; var talk_image: TextureRect; var help: Label

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
var _priority_placeholder: Control; var priority_placeholder: Control:
	get: return _from(priorities_scroll, &"_priority_placeholder", ^"stack/placeholder")
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
var _inventory_bag_placeholder: Control; var inventory_bag_placeholder: Control:
	get: return _from(inventory_scroll, &"_inventory_bag_placeholder", ^"stack/back/placeholder")
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
var _status_grid: GridContainer; var status_grid: GridContainer:
	get:
		if _status_grid == null: _status_grid = load(Def.status).instantiate()
		return _status_grid

# add status

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

@onready var ui: Window = get_window()
@onready var resize_timer: Timer = Timer.new()

func setup_hud() -> void:
	right.drag_ended.connect(right_mouse_drag)
	left.drag_ended.connect(left_mouse_drag)

func _ready():
	get_viewport().connect(^"size_changed", resize_timer.start)
	HUD.add_child(resize_timer)
	resize_timer.time = 0.25
	resize_timer.one_shot = true
	resize_timer.connect(_on_resize_timeout)
	resize_timer.start()

func _on_resize_timeout():
	if ui.size.x > ui.size.y:
		if _inventory_scroll != null: status_grid.columns = 2
	else:
		if _inventory_scroll != null: status_grid.columns = 1
	print("viewport size has stabilized - do performance-heavy stuff")

var fixed_hud: bool = false
var panel_open: int = -1

enum { TOP, LEFT, BOTTOM, RIGHT, T_OFF = 5, B_OFF = 5 }

func left_mouse_drag() -> void:
	if left.offset == 0:
		if _inventory_scroll != null:
			_stats_stack.remove_child(side_inventory)
			_inventory_placeholder.add_sibling(side_inventory)
	else:
		if _inventory_scroll != null:
			_inventory_stack.remove_child(side_inventory)
			_stats_placeholder.add_sibling(side_inventory)

func right_mouse_drag() -> void:
	if right.offset == 0:
		if _inventory_scroll != null:
			_inventory_bag_placeholder.remove_child(status_grid)
			_priority_placeholder.add_sibling(status_grid)
	else:
		if _inventory_scroll != null:
			_priority_placeholder.remove_child(status_grid)
			_inventory_bag_placeholder.add_sibling(status_grid)

func drag_hud() -> void:
	if left.offset != 0:
		left.offset = 0; left_mouse_drag()
	if right.offset != 0:
		right.offset = 0; right_mouse_drag()
	fixed_hud = !fixed_hud
	if fixed_hud:
		top.offset = T_OFF
		bottom.offset = B_OFF
	else:
		top.offset = 0
		bottom.offset = 0

func drag_specific(panel: int) -> void:
	if left.offset != 0:
		left.offset = 0; left_mouse_drag()
	if right.offset != 0:
		right.offset = 0; right_mouse_drag()
	top.offset = 0
	bottom.offset = 0
	if panel_open == panel:
		panel_open = -1
		if fixed_hud:
			top.offset = T_OFF
			bottom.offset = B_OFF
		return
	match panel:
		TOP: top.offset = T_OFF
		BOTTOM: bottom.offset = B_OFF
		LEFT: left.offset = L_OFF; left_mouse_drag()
		RIGHT: right.offset = R_OFF; right_mouse_drag()
	panel_open = panel
