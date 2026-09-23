class_name TheWorld extends CanvasLayer

enum { LEVEL, LOGIC, BOX = 2, POS = 4, AURA = 6, RESOURCE = 7, STATUS = 8,
	INVENTORY = 10, BESTIARY = 38, NOTES = 39, BOOKS = 40, CHESTS = 41, SECRETS = 42 }
enum { SETTINGS, SAVES, ACHIEVEMENTS, DIFFICULTY = 0, PART, DUNGEON, TRANSITION, PROGRESSED, BAG = 7 }

var session: PackedInt64Array

var level: LevelRoot
var adversary: Adversary
var action: Action
var trades: Trades

enum { CURRENTS, PLATFORMS, PLACES }
var size: PackedByteArray = [0, 0, 0]

var fire: GPUParticles2D; var rain: GPUParticles2D

func check(type: int) -> int: return session[type]
func unlock(type: int, slot: int) -> void: session[type] = Def.to1(session[type], slot)

func get_part(type: int, slot: int) -> int: return Def.byte(session[type], slot)
func set_part(type: int, slot: int, value: int) -> void: session[type] = Def.to_byte(session[type], slot, value)

func get_stat(type: int, slot: int) -> int: return Def.short(session[type], slot)
func set_stat(type: int, slot: int, value: int) -> void: session[type] = Def.to_short(session[type], slot, value)

func get_item(bag: int, slot: int) -> int: return Def.short(session[INVENTORY + BAG * bag + (slot >> Def.PART_BYTE)], slot & Def.HALF_BYTE)
func set_item(bag: int, slot: int, item: int) -> void:
	var no: int = INVENTORY + BAG * bag + (slot >> Def.PART_BYTE)
	session[no] = Def.to_short(session[no], slot & Def.HALF_BYTE, item)

# TIMING
var dialog_timer: Timer = Timer.new(); var station_timer: Timer = Timer.new()
var debug_timer: Timer

@onready var tree: SceneTree = get_tree()
@onready var ui: Window = get_window()

func _ready() -> void:
	layer = 2
	level.load_level()
	
	interact = WorldInteraction.new()
	aura = Adversary.new()
	trade = HeroTrade.new()
	
	if level.group:
		entity[HUD.hero].position = level.group.position
		level.group.reparent(entity[HUD.hero])
		level.group.position = Vector2.ZERO

	station_timer.timeout.connect(action.enter_cooldown)
	dialog_timer.timeout.connect(talking)

func next_hero() -> int: return (HUD.hero + 1) & Def.ROCK

#var session: PackedInt64Array = []
 # model : L1 (SCORE)P2 E4 A2 N4 S8 B4 A2 R2

func _init() -> void:
	state[BODY] = Def.to0(state[BODY], RUN)
	session = FileAccess.get_file_as_bytes(Def.saves).to_int64_array()

var level_path: PackedStringArray = ["_world", "_cave_origin", "_cave_smoke", "_cave_spark", "_temple_ancient", "_credits"]
var level_no: PackedByteArray = [0, 1, 8, 15, 27, 36]
var transition_part: int = 0

func load_scene(no: int, part: int = 0) -> void:
	var transit: String
	if part == 0:
		transit = ""
		for i in range(0, len(level_path)):
			if level_no[i] == no:
				transit = level_path[i]
				break
	else:
		transit = str("_", part)
	print_debug(tree.change_scene_to_file("res://def/dungeon/" + str(no).pad_zeros(1) + transit + ".tscn"))

func load_transition() -> void:
	var no: int = get_part(LEVEL, DUNGEON)
	if get_part(LEVEL, TRANSITION) == 0:
		if transition_part < 9:
			set_part(LEVEL, TRANSITION, transition_part)
			load_scene(no, transition_part)
		elif transition_part < 14:
			set_part(LEVEL, TRANSITION, transition_part)
			load_scene(no - 1)
		else:
			set_part(LEVEL, TRANSITION, transition_part)
			load_scene(no + 1)
	else:
		set_part(LEVEL, TRANSITION, transition_part)
		if transition_part < 9:
			load_scene(no - 1, transition_part)
		else:
			load_scene(no, transition_part - 9)

var state: int = 0

var navigation: Array
var hints: CompressedTexture2DArray = preload("res://icon/help/z_master.svg")

var up_transit: ColorRect; var down_transit: ColorRect; var help_card: Label


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
	if help_card == null:
		help_card = load(Def.card).instantiate()
		game.help.add_child(help_card)
	help_card.show()
	var tween: Tween = game.create_tween()
	tween.tween_property(help_card, ^"modulate", Color.WHITE, 1)
	help_card.text = tr(Def.hints[of])



enum { IS_FULL }

var text: PackedStringArray = ["Полегче с этим."]

func add_log(caption: String) -> void:
	var line: Label = logs.instantiate()
	HUD.game.log.add_child(line)
	line.text = caption

func notify(type: int) -> void: add_log(text[type])

var transit_type: int = GATE_IN
enum { LADDER_DOWN, LADDER_UP, GATE_IN, GATE_OUT, GATE_BOTH }
const BLACK_TRANSPARENT: Color = Color(0, 0, 0, 255)

func gate_both(from: float, to: float) -> Tween:
	up_transit.scale.y = from
	down_transit.scale.y = from
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(up_transit, ^"scale.y", to, 0.5)
	tween.tween_property(down_transit, ^"scale.y", to, 0.5)
	return tween

func gate_enter(from: Color, to: Color) -> void:
	up_transit.color = from
	up_transit.scale.y = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(up_transit, ^"color", to, 0.5)
	tween.tween_callback(load_transition)

func ladder_exit(main: ColorRect) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(main, ^"scale.y", 0.0, 0.5)
	tween.tween_callback(func(): main.hide())

func ladder_enter(main: ColorRect, side: ColorRect) -> void:
	var tween: Tween = create_tween(); main.scale.y = 0.0
	tween.tween_property(main, ^"scale.y", 1.0, 0.5)
	tween.tween_callback(func(): side.scale.y = 1.0; side.show(); load_transition())

func exit_transit() -> void:
	match transit_type:
		GATE_BOTH: gate_both(0.5, 0).tween_callback(tree.reload_current_scene)
		GATE_OUT, GATE_IN:
			var tween: Tween = create_tween()
			tween.tween_property(up_transit, ^"color", Color.TRANSPARENT, 0.5)
			tween.tween_callback(func(): up_transit.hide())
		LADDER_DOWN: ladder_exit(down_transit)
		LADDER_UP: ladder_exit(up_transit)

func entry_transit(type: int) -> void:
	transit_type = type
	up_transit.color = Color.BLACK
	match transit_type:
		GATE_BOTH: gate_both(0, 0.5).tween_callback(tree.reload_current_scene)
		GATE_OUT: gate_enter(Color.TRANSPARENT, Color.WHITE)
		GATE_IN: gate_enter(BLACK_TRANSPARENT, Color.BLACK)
		LADDER_DOWN: ladder_enter(up_transit, down_transit)
		LADDER_UP: ladder_enter(down_transit, up_transit)

var markers: Array[TextureRect] = []

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

enum { FPS, GPU }; var _debug_title: Label; var _debug_status: Label; var _debug_state: int
const FORMAT_MB: String = "\n%0.2f"; var BYTE_CLUSTER: float = 1.0 / 1048576 # 1024^2

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

func game_exit() -> void: tree.quit()

func main_menu() -> void:
	game.hide()
	pause.hide()
	print(tree.change_scene_to_file(&"res://def/hud/main.tscn"))

func game_start() -> void:
	set_game()
	for i in range(0, SECRETS): session[i] = 0
	# TODO RESET GAME stats like HP
	load_scene(1)
	gate_both(0.5, 0)

func game_continue() -> void:
	set_game()
	load_scene(get_part(LEVEL, DUNGEON), get_part(LEVEL, TRANSITIONS))
	gate_both(0.5, 0)

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
		talk_border = controls.get_node(^"dialog/talk/border")
		talk_image = controls.get_node(^"dialog/talk/border/image")
		dialogs = controls.get_node(^"dialog/talk")
		logs = controls.get_node(^"controls/logs")
		help = controls.get_node(^"middle/help")

var game: Control; var pause: Control; var settings: Control; var information: Control; var sound: Control
var right: HSplitContainer; var left: HSplitContainer; var top: VSplitContainer; var bottom: VSplitContainer; var controls: MarginContainer
var right_priorities: PanelContainer; var left_stats: PanelContainer; var top_inventory: PanelContainer; var bottom_ability: PanelContainer

var dialogs: RichTextLabel; var talk_dialog: Label; var talk_border: PanelContainer; var talk_image: TextureRect
var fix_log: Label; var logs: RichTextLabel; var help: Label

func set_stats() -> void:
	stats_scroll = load("res://def/hud/game/stats.tscn").instantiate()
	stats_description = stats_scroll.get_node(^"description")
	stats_chats = stats_scroll.get_node(^"stats_chats")
	power_stat = stats_scroll.get_node(^"margin/stack/power")
	power_base = power_stat.get_node(^"base")
	power_next = power_stat.get_node(^"next")
	influence_stat = stats_scroll.get_node(^"margin/stack/influence")
	influence_base = influence_stat.get_node(^"base")
	influence_next = influence_stat.get_node(^"next")
	vitality_stat = stats_scroll.get_node(^"margin/stack/vitality")
	vitality_base = vitality_stat.get_node(^"base")
	vitality_next = vitality_stat.get_node(^"next")
	reaction_stat = stats_scroll.get_node(^"margin/stack/reaction")
	reaction_base = reaction_stat.get_node(^"base")
	reaction_next = reaction_stat.get_node(^"next")
	for node in stats_scroll.get_node(^"margin/stack").get_children():
		side_items.append()

func set_priorities() -> void:
	priorities_scroll = load("res://def/hud/game/priorities.tscn").instantiate()
	priority_progress = priorities_scroll.get_node(^"stack/priority/progress")
	priority_placeholder = priorities_scroll.get_node(^"stack/placeholder")
	perks = priorities_scroll.get_node(^"stack/perks")
	pages = priorities_scroll.get_node(^"stack/pages")
	books = priorities_scroll.get_node(^"stack/books")
	pursuit = priorities_scroll.get_node(^"stack/priority/pursuit")
	self_control = priorities_scroll.get_node(^"stack/priority/self_control")
	tenacity = priorities_scroll.get_node(^"stack/priority/tenacity")

func set_ability() -> void:
	ability_scroll = load("res://def/hud/game/ability.tscn").instantiate()
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
	inventory_scroll = load("res://def/hud/game/inventory.tscn").instantiate()
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
var power_next: ProgressBar; var influence_next: ProgressBar
var vitality_next: ProgressBar; var reaction_next: ProgressBar

## UI PRIORITY
var priorities_scroll: ScrollContainer
var priority_progress: ProgressBar; var priority_placeholder: Control
var perks: ItemList; var pages: ItemList; var books: VBoxContainer
var pursuit: Button; var self_control: Button; var tenacity: Button

# add status
var fixed_hud: bool = false
var panel_open: int = -1

enum { TOP, LEFT, BOTTOM, RIGHT, T_OFF = 5, B_OFF = 5 }

func setup_hud() -> void:
	top.drag_started.connect(top_mouse_drag)
	bottom.drag_started.connect(bottom_mouse_drag)
	right.drag_started.connect(right_mouse_drag)
	left.drag_started.connect(left_mouse_drag)

func left_mouse_drag() -> void:
	if stats_scroll == null:
		left.drag_started.disconnect(left_mouse_drag)
		set_stats()

func right_mouse_drag() -> void:
	if priority_scroll == null:
		right.drag_started.disconnect(right_mouse_drag)
		set_priority()

func top_mouse_drag() -> void:
	if inventory_scroll == null:
		top.drag_started.disconnect(top_mouse_drag)
		set_inventory()

func bottom_mouse_drag() -> void:
	if ability_scroll == null:
		bottom.drag_started.disconnect(bottom_mouse_drag)
		set_ability()


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
