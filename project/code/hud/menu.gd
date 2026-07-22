class_name Menu extends RefCounted

enum { PAUSE, GAME }

var state: int
var no: int = 0
var card: Button

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
