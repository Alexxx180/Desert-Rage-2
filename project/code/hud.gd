class_name TheWorld extends CanvasLayer

enum { LEVEL, LOGIC, BOX = 2, POS = 4, AURA = 6, RESOURCE = 7, STATUS = 8,
	INVENTORY = 10, BESTIARY = 38, NOTES = 39, BOOKS = 40, CHESTS = 41, SECRETS = 42 }
enum { SETTINGS, SAVES, ACHIEVEMENTS, DIFFICULTY = 0, PART, DUNGEON, PROGRESSED, BAG = 7 }

var session: PackedInt64Array

var level: LevelRoot
var adversary: Adversary
var action: Action
var trades: Trades

enum { CURRENTS, PLATFORMS, PLACES }
var size: PackedByteArray = [0, 0, 0]

var fire: GPUParticles2D; var rain: GPUParticles2D

func check(type: int) -> int: return session[type]
func unlock(type: int, slot: int) -> void:
	session[type] = Def.to1(session[type], slot)

func get_part(type: int, slot: int) -> int:
	return Def.byte(session[type], slot)

func set_part(type: int, slot: int, value: int) -> void:
	session[type] = Def.to_byte(session[type], slot, value)

func get_stat(type: int, slot: int) -> int:
	return Def.short(session[type], slot)
	
func set_stat(type: int, slot: int, value: int) -> void:
	session[type] = Def.to_short(session[type], slot, value)

func get_item(bag: int, slot: int) -> int:
	return Def.short(session[INVENTORY + BAG * bag + (slot >> Def.PART_BYTE)], slot & Def.HALF_BYTE)

func set_item(bag: int, slot: int, item: int) -> void:
	var no: int = INVENTORY + BAG * bag + (slot >> Def.PART_BYTE)
	session[no] = Def.to_short(session[no], slot & Def.HALF_BYTE, item)

func new_hero(no: int) -> CharacterBody2D:
	if HUD.level.entity[no] == null:
		var hero: CharacterBody2D = load(Def.ray if no == Def.RAY else Def.rock).instantiate()
		hero.name = &"ray" if no == Def.RAY else &"rock"
		hero.no = no
		add_child(hero)
		return hero
	return entity[no]

func load_hero(that: int) -> void:
	if entity[that] == null:
		entity[that] = new_hero(that)

# TIMING
var dialog_timer: Timer = Timer.new()
var debug_timer: Timer

@onready var tree: SceneTree = get_tree()
@onready var ui: Window = get_window()

func _ready() -> void:
	layer = 2
	level.load_level()
	load_hero(HUD.hero)
	
	interact = WorldInteraction.new()
	aura = Adversary.new()
	trade = HeroTrade.new()
	
	if level.group:
		entity[HUD.hero].position = level.group.position
		level.group.reparent(entity[HUD.hero])
		level.group.position = Vector2.ZERO

	dialog_timer.timeout.connect(talking)

func next_hero() -> int: return (HUD.hero + 1) & Def.ROCK

#var session: PackedInt64Array = []
 # model : L1 (SCORE)P2 E4 A2 N4 S8 B4 A2 R2 

func _init() -> void:
	state[BODY] = Def.to0(state[BODY], RUN)
	session = FileAccess.get_file_as_bytes(Def.saves).to_int64_array()

var level_path: PackedStringArray = ["_world", "_cave_origin",
	"_cave_smoke", "_cave_spark", "_temple_ancient", "_credits"]
var level_no: PackedByteArray = [0, 1, 8, 15, 27, 36]
var transition_no: int = 0
var transition_part: int = 0

func load_scene(no: int, part: String = "") -> void:
	if part != "":
		for i in range(0, len(level_path)):
			if level_no[i] == no:
				part = level_path[i]
				break
	print_debug(tree.change_scene_to_file("res://def/dungeon/" + str(no).pad_zeros(1) + part + ".tscn"))

func load_transition(part: int = 0) -> void:
	var scene: String = str(no).pad_zeros(1)
	if transition_part == 0:
		if part < 9:
			transition_part = part
			load_scene(no, str("_", part))
		elif part < 14:
			transition_part = 0
			load_scene(no - 1)
		else:
			transition_part = 0
			load_scene(no + 1)
	else:
		transition_part = part
		if part < 9:
			load_scene(no - 1, str("_", part))
		else:
			load_scene(no, str("_", part - 9))

func game_exit() -> void: tree.quit()
func game_start() -> void: print_debug(tree.change_scene_to_file(&"res://def/dungeon/01_cave_origin.tscn"))
func game_continue() -> void: game_start() # TODO check save date


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
	card.text = tr(Def.hints[of])



enum { IS_FULL }

var text: PackedStringArray = ["Полегче с этим."]

func add_log(caption: String) -> void:
	var line: Label = logs.instantiate()
	HUD.game.log.add_child(line)
	line.text = caption

func notify(type: int) -> void: add_log(text[type])

var transit_type: int = 0
enum { LADDER_DOWN, LADDER_UP, GATE_IN, GATE_OUT }

func gate_enter(from: Color, to: Color) -> void:
	up_transit.color = from
	up_transit.scale.y = 1.0
	create_tween().tween_property(up_transit, ^"color", to, 0.5)

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
			tween.tween_property(up_transit, ^"color", Color.TRANSPARENT, 0.5)
			tween.tween_callback(func(): up_transit.hide())
		LADDER_DOWN: ladder_exit(down_transit)
		LADDER_UP: ladder_exit(up_transit)

const BLACK_TRANSPARENT: Color = Color(0, 0, 0, 255)

func entry_transit(type: int) -> void:
	up_transit.color = Color.BLACK
	match type:
		GATE_OUT:
			up_transit.color = Color.WHITE
			gate_enter(Color.TRANSPARENT, Color.WHITE)
		GATE_IN: gate_enter(BLACK_TRANSPARENT, Color.BLACK)
		LADDER_DOWN: ladder_enter(up_transit, down_transit)
		LADDER_UP: ladder_enter(down_transit, up_transit)

func start_transition(level: String, _floor_diff: int = 0, type: int = LEDGE) -> void:
	blackout.scene = level
	match type:
		WAY: blackout.as_way(self, Color.BLACK, true)
		LEDGE: blackout.as_ledges(ledges, Color.BLACK, true)

enum { FAST_MAX = 5 }

var _main_marker: TextureRect
var _side_marker: TextureRect
var loaded_items: bool = false

func set_marker(before: int, after: int) -> void:
	if HUD.hero == Def.RAY:
		_main_items[before].remove_child(_main_marker)
		_main_items[after].add_child(_main_marker)
	else:
		_side_items[before].remove_child(_side_marker)
		_side_items[after].add_child(_side_marker)

func fast_panel_swap(offset: int) -> void:
	var before: int = HUD.inventory.fast_panel[HUD.hero]
	var result: int = before + offset
	if result > FAST_MAX:
		HUD.inventory.fast_panel[HUD.hero] = 0
	elif result < 0:
		HUD.inventory.fast_panel[HUD.hero] = FAST_MAX - 1
	else:
		var target: Vector2i = Vector2i(0, -1) if offset < 0 else Vector2i(FAST_MAX - 1, FAST_MAX)
		for i in range(HUD.inventory.fast_panel[HUD.hero] + offset, target.y, offset):
			if i == target.x or HUD.get_item(HUD.hero, i) != 0:
				HUD.inventory.fast_panel[HUD.hero] = i
				if loaded_items:
					set_marker(before, i)
				break

func fast_panel_select(slot: int) -> void:
	if slot == HUD.inventory.fast_panel[HUD.hero]: return
	elif slot == FAST_MAX:
		HUD.inventory.fast_panel[HUD.hero] = slot; return
	var result: int = 0
	for i in range(0, FAST_MAX):
		if HUD.get_item(HUD.hero, slot) != 0:
			result += 1; continue
		if result == slot:
			result = i; break
	if result == slot:
		HUD.inventory.fast_panel[HUD.hero] = result
		if _inventory_scroll == null:
			set_marker(before, i)
			_main_items[result]



var started_dialog: bool = false
var queue: PackedByteArray = []
var length: Vector2i = Vector2i.ZERO
var who: PackedStringArray = ["RAY", "ROCK", "DID", "???"]
var face: PackedStringArray = ["look", "rage", "grin", "smile", "confirm",
	"tired", "but", "sign", "amaze", "respect", "anger", "play", "rain", "scare"]

enum { CURRENT, END_MESSAGE, DIALOG_FROM = 1, DIALOG_TO = 2, DIALOG_CURSOR = 3 }

func add_dialog(from: int, to: int) -> void: # LEVEL USUALLY set after level finish or on load
	length[END_MESSAGE] += DIALOG_CURSOR
	if length[END_MESSAGE] >= len(queue):
		queue.append(HUD.get_part(LEVEL))
		queue.append(from)
		queue.append(to)
	else:
		queue[length[CURRENT]] = HUD.get_part(LEVEL)
		queue[length[CURRENT] + DIALOG_FROM] = from
		queue[length[CURRENT] + DIALOG_TO] = to
	if !started_dialog:
		started_dialog = true
		timeout_talk()

func ready_timer() -> void:
	dialog_timer.connect(timeout_talk)

func timeout_talk() -> void:
	var message: int = queue[length[CURRENT] + DIALOG_FROM]
	if message >= queue[length[CURRENT] + DIALOG_TO]:
		length[CURRENT] += DIALOG_CURSOR
		if length[CURRENT] >= length[END_MESSAGE]:
			length = Vector2i.ZERO
			if dialog_on: dialogs.hide()
			return
	else:
		message += 1
		queue[length[CURRENT] + DIALOG_FROM] = message
	if dialog_on:
		dialogs.show()
		var key: String = "L%d_%d" % [queue[length[CURRENT]], message]
		talk_dialog.text = key
		talk_dialog.visible_characters = 0
		var tween: Tween = create_tween()
		tween.tween_property(talk_dialog, ^"visible_characters", len(tr(key)), 0.5)
		tween.tween_callback(dialog_timer.start)
	else:
		dialog_timer.start()


enum { STATUS_TYPE, STATUS_TIME, STATUS_X = -7, STATUS_Y = 25 }

var entity_status: Array[Array] = [[],  []] # Sprite2D
var enemy_status: PackedInt64Array = []
var status_process: bool = false

func status_feedback(type: int, entity: int) -> void:
	match type:
		BURN: pass
		POISON: pass

func status_drawback() -> void:
	status_process = !status_process
	if !status_process: return

	if (entity_count + Def.PARTY) > len(hero_status):
		for i in range(len(entity_status), entity_count + Def.PARTY):
			hero_status.append([null, null, null, null])

	for e in entity:
		for i in range(0, 4):
			var status: Vector2i = Def.h_byte(get_part(STATUSES + e, i) if e < Def.PARTY else enemy_status[e - Def.PARTY])
			if status[STATUS_TIME] == 0: continue

			status[STATUS_TIME] -= 1
			if status[STATUS_TYPE] == 0:
				entity_status[e].hide()
				entity_status[e].position = Vector2(0, STATUS_Y * i)
			else:
				entity_status[e].position = Vector2(STATUS_X * status[STATUS_TIME], STATUS_Y * i)
				status_feedback(type)

			var result: int = status[STATUS_TYPE] << Def.MASK3 | status[STATUS_TIME]
			if entity < Def.PARTY:
				set_part(STATUSES + e, i, result)
			else:
				enemy_status[e - Def.PARTY] = Def.to_x(Def.BYTE, enemy_status[e - Def.PARTY], i, result)


var _debug_title: Label; var _debug_status: Label; var _debug_state: int

enum { FPS, GPU }

var BYTE_CLUSTER: float = 1.0 / 1048576 # 1024^2
const FORMAT_MB: String = "\n%0.2f"

func _get_vram() -> String: return FORMAT_MB % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) * BYTE_CLUSTER)
func _don(debug_type: int) -> bool: return Def.of(_debug_state, debug_type)
func debug_drawback() -> void:
	_debug_status.text = str(("\n" + str(Engine.get_frames_per_second())) if _don(FPS) else "",  _get_vram() if _don(GPU) else "")
func debug_change() -> void:
	_debug_status.text = str("\nFPS" if _don(FPS) else "", "\nVRAM" if _don(GPU) else "")
	if debug_timer == null:
		debug_timer = Timer.new()
		debug_timer.connect(debug_drawback)
		add_child(debug_timer)
	debug_timer.start()

func drawback(asset: Node2D) -> void:
	var fov: VisibleOnScreenNotifier2D = asset.get_node(^"fov")
	fov.screen_entered.connect(asset.show)
	fov.screen_exited.connect(asset.hide)







const TIME: PackedFloat32Array = [0.2, 0.5]
enum { TIME_FLIP, TIME_HOOD }

enum { MOVE, ACT, KICK }

var card_text: Array[Button] = []

func translate_all_cards() -> void:
	for card in card_text:
		translate_card(card.help, card.no)

func translate_card(card: Label, no: int) -> void:
	match no:
		MOVE: card.text = tr(Def.hints[card.no]) % [0]
		ACT: card.text = tr(Def.hints[card.no]) % 1
		KICK: card.text = tr(Def.hints[card.no]) % 2
		_: card.text = tr(Def.hints[card.no])

func load_card(next: int) -> void:
	var card: Button = load(Def.card).instantiate()
	ability_help.add_child(card)
	card.no = next
	card.image.texture = ImageTexture.create_from_image(Def.help.get_layer_data(next))
	card.help.visible_characters = 20
	card_text.append(card)
	translate_card(card.help, next)

func flip_card(card: Button) -> void:
	var shown: bool = false
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(func(x: float):
		if !shown and -0.5 <= x and x <= 0.5:
			shown = true
			card.image.visible = !card.image.visible
			card.help.visible_characters = 20 if card.image.visible else -1
		self.scale = Vector2(abs(x), 1), -1.0, 1.0, TIME[TIME_FLIP])

func new_game() -> void:
	set_game()
	pass

func continue_game() -> void:
	set_game()
	pass

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

var dialogs: RichTextLabel; var talk_dialog: Label; var talk_border: PanelContainer; var talk_image: TextureRect
var fix_log: Label; var logs: RichTextLabel; var help: Label

func set_stats() -> void:
	stats_scroll = _lazy(left_stats, &"_stats_scroll", &"res://def/hud/game/stats.tscn")
	stats_description = stats_scroll.get_node(^"description")
	stats_chats = stats_scroll.get_node(^"stats_chats")
	power_stat = stats_scroll.get_node(^"margin/stack/power")
	power_base = power_stat.get_node(^"base")
	influence_stat = stats_scroll.get_node(^"margin/stack/influence")
	influence_base = influence_stat.get_node(^"base")
	influence_stat = stats_scroll.get_node(^"margin/stack/influence")
	influence_base = influence_stat.get_node(^"base")
	vitality_stat = stats_scroll.get_node(^"margin/stack/vitality")
	vitality_base = influence_stat.get_node(^"base")
	reaction_stat = stats_scroll.get_node(^"margin/stack/reaction")
	reaction_base = reaction_stat.get_node(^"base")
	for node in stats_scroll.get_node(^"margin/stack").get_children():
		side_items.append()

func set_priorities() -> void:
	priorities_scroll = _lazy(right_priorities, &"_priorities_scroll", &"res://def/hud/game/priorities.tscn")
	priority_progress = priorities_scroll.get_node(^"stack/priority/progress")
	priority_placeholder = priorities_scroll.get_node(^"stack/placeholder")
	perks = priorities_scroll.get_node(^"stack/perks")
	pages = priorities_scroll.get_node(^"stack/pages")
	books = priorities_scroll.get_node(^"stack/books")
	pursuit = priorities_scroll.get_node(^"stack/priority/pursuit")
	self_control = priorities_scroll.get_node(^"stack/priority/self_control")
	tenacity = priorities_scroll.get_node(^"stack/priority/tenacity")

func set_ability() -> void:
	ability_scroll = _lazy(right_ability, &"_ability_scroll", &"res://def/hud/game/ability.tscn")
	ability_skills = ability_scroll.get_node(^"stack/skills")
	ability_title = ability_scroll.get_node(^"stack/title")
	ability_effect = ability_scroll.get_node(^"stack/effect")
	ability_help = ability_scroll.get_node(^"stack/help")
	ability_research = ability_scroll.get_node(^"stack/status/research")
	ability_health = ability_scroll.get_node(^"stack/status/health")
	ability_health_bar = ability_scroll.get_node(^"stack/status/health/bar")
	ability_score = ability_scroll.get_node(^"stack/status/score")
	ability_meter = ability_scroll.get_node(^"stack/status/score/meter")
	ability_pallete = ability_scroll.get_node(^"stack/pallete")

func set_inventory() -> void:
	inventory_scroll = _lazy(top_inventory, &"_inventory_scroll", &"res://def/hud/game/inventory.tscn")
	inventory_bag_placeholder = inventory_scroll.get_node(^"stack/back/placeholder")
	inventory_bestiary = inventory_scroll.get_node(^"stack/bestiary")
	bestiary_number = inventory_bestiary.get_node(^"number")
	bestiary_effect = inventory_bestiary.get_node(^"effect")
	inventory_status = inventory_scroll.get_node(^"stack/bag/status")
	inventory_status = inventory_scroll.get_node(^"stack/bag/status")
	for i in [^"stack/bag/ray", ^"stack/bag/rock"]:
		main_items.append(inventory_scroll.get_node(i).get_children())

var inventory_scroll: ScrollContainer; var inventory_bag_placeholder: Control
var inventory_bestiary: HFlowContainer; var bestiary_number: Label
var bestiary_effect: Label; var inventory_status: GridContainer

var _side_equip: bool = false
var main_items: Array[Array] = []
var side_items: Array[Button] = []

## UI ABILITY
var ability_scroll: ScrollContainer
var ability_skills: ItemList; var ability_title: ProgressBar
var ability_effect: ProgressBar; var ability_help: HFlowContainer
var ability_research: Button; var ability_health: Button
var ability_health_bar: ProgressBar; var ability_score: Label
var ability_meter: Label; var ability_pallete: ItemList

## UI STATS
var _stat_bar: PackedScene = null
var stats_scroll: ScrollContainer
var stats_description: ScrollContainer; var stats_chats: ScrollContainer
var power_stat: Button; var power_base: ProgressBar
var influence_stat: Button; var influence_base: ProgressBar
var vitality_stat: Button; var vitality_base: ProgressBar
var reaction_stat: Button; var reaction_base: ProgressBar
var _power_next: ProgressBar; var power_next: ProgressBar:
	get: return _lazy(power_stat, &"_power_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _influence_next: ProgressBar; var influence_next: ProgressBar:
	get: return _lazy(influence_stat, &"_influence_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _vitality_next: ProgressBar; var vitality_next: ProgressBar:
	get: return _lazy(vitality_stat, &"_vitality_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")
var _reaction_next: ProgressBar; var reaction_next: ProgressBar:
	get: return _lazy(reaction_stat, &"_reaction_next", &"res://def/hud/game/stats_bar.tscn", &"_stat_bar")

## UI PRIORITY
var priorities_scroll: ScrollContainer
var priority_progress: ProgressBar; var priority_placeholder: Control
var perks: ItemList; var pages: ItemList; var books: VBoxContainer
var pursuit: Button; var self_control: Button; var tenacity: Button

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



func setup_hud() -> void:
	right.drag_ended.connect(right_mouse_drag)
	left.drag_ended.connect(left_mouse_drag)



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
