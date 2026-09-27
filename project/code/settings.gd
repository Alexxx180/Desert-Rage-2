class_name Settings extends RefCounted

enum {
	H_RAY, H_ROCK, H_ZARAH, H_ARTHUR, TITLE, PAUSE, ENDING,
	P_DESERT, T_DESERT, P_WATER, T_WATER, P_AIR, T_AIR,
	P_FOREST, T_FOREST, P_HILLS, T_HILLS, P_MOTOR, T_MOTOR, P_MECHA, T_MECHA,
	DIALOG, NIGHT, ACCENT, ESCAPE,
	
	BOSSES = 64, MINOR_BOSS, MAJOR_BOSS, SPIDER, WORM, SHADOW_REAPER, PHARAOH,
	MASTER,
	
	CP_CAVES1 = 128, CT_CAVES1, CF_CAVES1, CP_CAVES2, CT_CAVES2, CF_CAVES2,
	CP_CAVES3, CT_CAVES3, CF_CAVES3,  CP_TEMPLE1, CT_TEMPLE1, CF_TEMPLE1,
	CP_TEMPLE2, CT_TEMPLE2, CF_TEMPLE2, CP_TEMPLE3, CT_TEMPLE3, CF_TEMPLE3,
	
	SP_ORIGIN = 256, ST_ORIGIN, SF_ORIGIN,  SP_SMOKE, ST_SMOKE, SF_SMOKE,
	SP_SPARK, ST_SPARK, SF_SPARK,  SP_SHADOW, ST_SHADOW, SF_SHADOW,
	SP_TEMPLE, ST_TEMPLE, SF_TEMPLE,
	
	HEROES_BLEND = 512, CAVES_BLEND = 520, TEMPLE_BLEND = 528
}

var playback_no: int = 0
var playback: PackedInt32Array = [TITLE, H_RAY,
	SP_ORIGIN, ST_ORIGIN, SF_ORIGIN, SPIDER, ACCENT,
	SP_SMOKE, ST_SMOKE, SF_SMOKE, P_DESERT, WORM,
	SP_SPARK, ST_SPARK, SF_SPARK, SHADOW_REAPER, NIGHT,
	SP_SHADOW, ST_SHADOW, SF_SHADOW, DIALOG, H_ROCK, PAUSE,
	SP_TEMPLE, ST_TEMPLE, SF_TEMPLE, PHARAOH, ENDING]
var _ost: PackedInt64Array

enum { DEFAULTED = -1, 
	LT_WORLD = 0, LT_ORIGIN_A = 1, LT_ORIGIN_B = 7, LT_SMOKE_A = 8,
	LT_SMOKE_B = 13, LT_SPARK_A = 14, LT_SPARK_B = 20, LT_SHADOW_A = 21,
	LT_SHADOW_B = 25, LT_TEMPLE_A = 26, LT_TEMPLE_B = 35, LT_CREDITS = 36 }

func toggle_ost(type: int, next: bool) -> void:
	_ost[type >> 6] = Def.to(_ost[type >> 6], type & ((1 << 64) - 1), next)

func check_ost(type: int) -> bool: return Def.of(_ost[type >> 6], type & ((1 << 64) - 1))
func _d(from: int, to: int) -> bool: return from <= level_no and level_no <= to

var level_no: int
var ost_no: int
var default_no: int
var collection_no: int
var fight_mode: int
var music_player: AudioStreamPlayer

func user_file(no: int) -> String: return "user://" + str(no).pad_zeros(2) + ".ogg"
func exists(no: int) -> bool: return check_ost(no) and _defuse(no)
func _defuse(no: int) -> bool:
	if FileAccess.file_exists(user_file(no)): return true
	toggle_ost(no, false)
	return false

enum { PEACE, TENSE, FIGHT, HERO_BLEND, FINISHED }

func set_fight_mode(mode: int) -> void:
	fight_mode = mode

func set_hero_theme(common: int) -> void:
	ost_no = HUD.hero if _blend(HEROES_BLEND) else common

func set_common_theme(common: int, no: int) -> bool:
	if Def.of(no, FINISHED):
		no = (Def.to(no, PEACE, !check_ost(common + 0)) |
			Def.to(no, TENSE, !check_ost(common + 1)) |
			Def.to(no, FIGHT, !check_ost(common + 2)))
		if fight_mode == 0 or (Def.of(no, TENSE) and Def.of(no, FIGHT)):
			set_hero_theme(DEFAULTED if Def.of(no, PEACE) else common)
		elif fight_mode == 1 or Def.of(no, FIGHT):
			set_hero_theme(common + 1)
		else:
			set_hero_theme(common + 2)
	elif Def.of(no, HEROES_BLEND):
		ost_no = HUD.hero
		default_no = HUD.hero
	else:
		return false
	return true

func set_theme(common: int, specific: int, defaulted: int, common_blend: bool, finished: bool) -> void:
	if finished:
		collection_no = int(_theme(common)) + int(_theme(common + 3)) + int(_theme(common + 6))
		collection_no = randi_range(0, collection_no)
	common += collection_no * 3
	default_no = defaulted
	var no: int = (Def.to(0, PEACE, !check_ost(specific + 0)) |
		Def.to(0, TENSE, !check_ost(specific + 1)) |
		Def.to(0, FIGHT, !check_ost(specific + 2)))
	no = Def.to(no, FINISHED, finished and (Def.of(no, PEACE) or common_blend))
	no = Def.to(no, HERO_BLEND, Def.of(no, TENSE) and Def.of(no, FIGHT) and _blend(HEROES_BLEND))
	if fight_mode == 0 or (Def.of(no, TENSE) and Def.of(no, FIGHT)):
		if !set_common_theme(common, no): ost_no = specific
	elif fight_mode == 1 or Def.of(no, FIGHT):
		if !set_common_theme(common, no): ost_no = specific + 1
	else:
		if !set_common_theme(common, no): ost_no = specific + 2

func play_theme(file: String, finished: bool) -> void:
	if finished:
		music_player.stream = AudioStreamOggVorbis.load_from_file(file)
		music_player.play()
	else:
		var pos: float = music_player.get_playback_position()
		music_player.stream = AudioStreamOggVorbis.load_from_file(file)
		music_player.play(pos)

func level_playback_enter(finished: bool = false, specific: int = DEFAULTED) -> void:
	if specific != DEFAULTED:
		ost_no = specific
		default_no = specific
	elif level_no == LT_WORLD:
		if fight_mode == 0:
			ost_no = P_DESERT
			default_no = P_DESERT
		elif _blend(HEROES_BLEND):
			ost_no = HUD.hero
			default_no = HUD.hero
		else:
			default_no = T_DESERT
			ost_no = T_DESERT
	elif _d(LT_ORIGIN_A, LT_ORIGIN_B): # check for fight mode on defaults
		set_theme(CP_CAVES1, SP_ORIGIN, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SMOKE_A, LT_SMOKE_B):
		set_theme(CP_CAVES1, SP_SMOKE, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SPARK_A, LT_SPARK_B):
		set_theme(CP_CAVES1, SP_SPARK, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SHADOW_A, LT_SHADOW_B):
		set_theme(CP_CAVES1, SP_SPARK, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_TEMPLE_A, LT_TEMPLE_B):
		set_theme(CP_TEMPLE1, SP_TEMPLE, CP_TEMPLE1, _blend(TEMPLE_BLEND), finished)
	elif level_no == LT_CREDITS:
		ost_no = ENDING
		default_no = ENDING
	if exists(ost_no):
		play_theme(user_file(ost_no), finished)
	else:
		play_theme("res://data/ost/music/" + str(default_no).pad_zeros(2) + ".ogg", finished)
		
enum { P_ORIGIN = 2, P_SMOKE = 7, P_SPARK = 12, P_SHADOW = 17, P_TEMPLE = 22,
	D_BOSSES = 8, D_COMMON = 16, D_SPECIFIC = 32 }

func _theme(no: int) -> bool: return Def.of(_ost[no >> D_COMMON], no & ((1 << 64) - 1))

func set_next_playback(idx: int, blend: int,
	common: int, specific: int, hero_blend: bool) -> void:
	if _blend(blend):
		var no: int = 1 + int(_theme(common + 3)) + int(_theme(common + 6))
		no = randi_range(0, no) * 3
		playback[idx] = common + no
		playback[idx + 1] = common + no + 1
		playback[idx + 2] = common + no + 2
	else:
		playback[idx] = specific
		playback[idx + 1] = specific + 1
		playback[idx + 2] = specific + 2
	if hero_blend and _blend(HEROES_BLEND):
		playback[idx + 2] = randi_range(H_RAY, H_ROCK + 1)

func finish_playback() -> void:
	playback_no = 0
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_ORIGIN, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SMOKE, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SPARK, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SHADOW, false)
	set_next_playback(P_ORIGIN, TEMPLE_BLEND, CP_CAVES1, SP_TEMPLE, false)

func _blend(_type: int) -> bool: return Def.byte(_ost[_type >> 6], _type & 64) < randi_range(0, 100)

enum { XBX, PS, N }

var gamepad_type: int = XBX
const button_layout: PackedStringArray = ["△□○✖", "ABXY", "ABYX"] # ❏▣⊹❣☜☞☟
const types: PackedStringArray = ["ps",  "xbox",  "xinput", "nintendo", "stk"]
const types_no: PackedByteArray = [0, 0,  1, 1,  2, 4]

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		gamepad_type = get_gamepad_type(Input.get_joy_name(0).to_lower())
		# process help hints

func get_gamepad_type(device: String) -> int:
	if device == "": return XBX
	for i in range(0, len(types_no), 2):
		for j in range(types_no[i], types_no[i + 1] + 1):
			if device.contains(types[j]): return i >> 1
	return XBX

var settings: MarginContainer
var content: ScrollContainer
var exit: Button; var controls: Button

var sound_head: Button
var music: HSlider; var music_manual: Button
var sound: HSlider; var sound_manual: Button
var interface: HSlider; var interface_manual: Button
var ost_system: Button

var xp_head: Button
var p1: Button; var p2: Button
var sensitivity: HSlider; var difficulty: Button
var deasy: Button; var dsuitable: Button; var dhard: Button
var language: Button; var screen: Button
var lenglish: Button; var lrussian: Button
var press: Button; var narrative: Button
var logs: Button; var help: Button

var keyboard_head: Button
var movement: Button; var actions: Button
var items: Button; var group: Button
var movement2: Button; var actions2: Button
var items2: Button; var saves: Button
var soundtrack: Button

var gamepad_head: Button
var g_movement: Button; var g_actions: Button
var g_items: Button; var g_group: Button

var sound_menu: Control

func set_settings() -> void:
	settings = load(Def.settings).instantiate()
	HUD.pause.hide()
	HUD.add_child(settings)
	content = settings.get_node(^"content")
	var o: VBoxContainer = content.get_node(^"options")
	exit = o.get_node(^"title/exit"); exit.pressed.connect(back_to_pause)
	controls = o.get_node(^"title/controls"); controls.pressed.connect(controls_focus)
	sound_head = o.get_node(^"sound_head"); sound_head.pressed.connect(back_to_start)
	music = o.get_node(^"sound/music"); music.drag_ended.connect(loudness_music)
	music_manual = o.get_node(^"sound/music/manual"); music_manual.pressed.connect(manual_music)
	sound = o.get_node(^"sound/sound"); sound.drag_ended.connect(loudness_sound)
	sound_manual = o.get_node(^"sound/sound/manual"); sound_manual.pressed.connect(manual_sound)
	interface = o.get_node(^"sound/interface"); interface.drag_ended.connect(loudness_interface)
	interface_manual = o.get_node(^"sound/interface/manual"); interface_manual.pressed.connect(manual_interface)
	ost_system = o.get_node(^"sound/system"); ost_system.pressed.connect(back_to_ost)
	xp_head = o.get_node(^"xp_head"); xp_head.pressed.connect(back_to_start)
	p1 = o.get_node(^"experience/p1")
	p2 = o.get_node(^"experience/p2")
	sensitivity = o.get_node(^"experience/sensitivity"); sensitivity.drag_ended.connect(set_sensitivity)
	difficulty = o.get_node(^"experience/difficulty"); difficulty.pressed.connect(show_difficulty)
	deasy = o.get_node(^"experience/deasy"); deasy.pressed.connect(set_easy)
	dsuitable = o.get_node(^"experience/dsuitable"); dsuitable.pressed.connect(set_suitable)
	dhard = o.get_node(^"experience/dhard"); dhard.pressed.connect(set_hard)
	language = o.get_node(^"experience/language"); language.pressed.connect(show_language)
	lenglish = o.get_node(^"experience/lenglish"); lenglish.pressed.connect(set_english)
	lrussian = o.get_node(^"experience/lrussian"); lrussian.pressed.connect(set_russian)
	screen = o.get_node(^"experience/screen"); screen.pressed.connect(set_screen)
	press = o.get_node(^"experience/press"); press.pressed.connect(set_press)
	narrative = o.get_node(^"experience/narrative"); narrative.pressed.connect(set_narrative)
	logs = o.get_node(^"experience/logs"); logs.pressed.connect(set_logs)
	help = o.get_node(^"experience/help"); help.pressed.connect(set_help)
	keyboard_head = o.get_node(^"keyboard_head"); keyboard_head.pressed.connect(back_to_start)
	movement = o.get_node(^"keyboard/movement") # as well as game presets
	actions = o.get_node(^"keyboard/actions")
	items = o.get_node(^"keyboard/items")
	group = o.get_node(^"keyboard/group")
	movement2 = o.get_node(^"keyboard/movement2")
	actions2 = o.get_node(^"keyboard/actions2")
	items2 = o.get_node(^"keyboard/items2")
	saves = o.get_node(^"keyboard/saves")
	soundtrack = o.get_node(^"keyboard/soundtrack")
	gamepad_head = o.get_node(^"gamepad_header"); gamepad_head.pressed.connect(back_to_start)
	g_movement = o.get_node(^"gamepad/movement")
	g_actions = o.get_node(^"gamepad/actions")
	g_items = o.get_node(^"gamepad/items")
	g_group = o.get_node(^"gamepad/group")

func update_difficulty() -> void: pass
func update_narrative() -> void: pass
func update_dialog() -> void: pass
func update_help() -> void: pass
func update_logs() -> void: pass
func update_language() -> void: TranslationServer.set_locale(locale_type[HUD.get_part(HUD.SETTINGS_SLIDERS, HUD.LANGUAGE)])
func update_press() -> void: pass
func update_screen() -> void:
	if HUD.look(HUD.SETTINGS, HUD.SCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

const locale_type: PackedStringArray = ["en", "ru"]
const LINEAR_SLIDER: float = 0.01; var current_loud: int = 0; var current_bus: int = 0
enum { BUS_MUSIC, BUS_SOUND, BUS_INTERFACE }
func back_to_start() -> void: content.scroll_vertical = 0
func back_to_pause() -> void: settings.hide(); HUD.pause.show()
func back_to_ost() -> void: settings.hide(); sound_menu.show()
func controls_focus() -> void: keyboard_head.grab_focus()# db_to_linear(value)
func set_narrative() -> void: HUD.took(HUD.SETTINGS, HUD.NARRATIVE); update_narrative()
func set_dialog() -> void: HUD.took(HUD.SETTINGS, HUD.DIALOG); update_dialog()
func set_logs() -> void: HUD.took(HUD.SETTINGS, HUD.LOGS); update_logs()
func set_help() -> void: HUD.took(HUD.SETTINGS, HUD.HELP); update_help()
func set_screen() -> void: HUD.took(HUD.SETTINGS, HUD.SCREEN); update_screen()
func set_press() -> void: HUD.took(HUD.SETTINGS, HUD.PRESS); update_press()

func show_few_options(part: int, options: Array[Button]) -> void: for i in range(0, len(options)): if i != part: options[i].show()
func get_languages() -> Array[Button]: return [lenglish, lrussian]
func show_language() -> void: show_few_options(HUD.get_part(HUD.SETTINGS_SLIDERS, HUD.LANGUAGE), get_languages())
func set_english() -> void: set_language(0)
func set_russian() -> void: set_language(1)
func set_language(no: int) -> void:
	for l in get_languages(): l.hide()
	HUD.set_part(HUD.SETTINGS_SLIDERS, HUD.LANGUAGE, no)
	update_language()

func get_difficulties() -> Array[Button]: return [deasy, dsuitable, dhard]
func show_difficulty() -> void: show_few_options(HUD.get_part(HUD.SAVES, HUD.DIFFICULTY), get_difficulties())
func set_difficulty(no: int) -> void: HUD.set_part(HUD.SAVES, HUD.DIFFICULTY, no); update_difficulty()
func set_easy() -> void: set_difficulty(1)
func set_suitable() -> void: set_difficulty(2)
func set_hard() -> void: set_difficulty(3)

func set_sensitivity(value: int) -> void: HUD.set_part(HUD.SETTING_SLIDERS, HUD.SENSITIVITY, int(value))
func loudness_bus(name: StringName, that: HSlider) -> void: AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), linear_to_db(that.value * LINEAR_SLIDER))
func loudness_music(value: int) -> void: loudness_bus(&"Master", music); music_manual.text = str(value)
func loudness_sound(value: int) -> void: loudness_bus(&"Sound", sound); sound_manual.text = str(value)
func loudness_interface(value: int) -> void: loudness_bus(&"Interface", interface); interface_manual.text = str(value)
func next_loudness(that: HSlider, next: int) -> void: that.value = next if that.value * 10 > 100 else int(that.value * 10 + next)
func manual_enable() -> void: pass
func manual_music() -> void: current_bus = BUS_MUSIC; manual_enable()
func manual_sound() -> void: current_bus = BUS_SOUND; manual_enable()
func manual_interface() -> void: current_bus = BUS_INTERFACE; manual_enable()
func manual_loudness(event: InputEvent) -> void:
	var next: int = -1
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE: next = current_loud
			KEY_ENTER: next = -2
			_:
				next = event.keycode - KEY_0
				if next < 0 and KEY_9 < next: next = -1
	elif event is InputEventJoypadButton:
		var offset: int = 5 if absf(Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)) > 0.2 else 0
		match event.button_index:
			JOY_BUTTON_X: next = offset + 1
			JOY_BUTTON_Y: next = offset + 2
			JOY_BUTTON_LEFT_SHOULDER: next = offset + 3
			JOY_BUTTON_RIGHT_SHOULDER: next = offset + 4
	elif event is InputEventJoypadMotion and event.axis == JOY_AXIS_TRIGGER_RIGHT:
		if absf(Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)) > 0.2:
			next = 0
		else:
			next = 5
	if next == -2:
		pass # stop operation
	elif next != -1:
		match current_bus:
			BUS_MUSIC: next_loudness(music, next); loudness_music(int(music.value))
			BUS_SOUND: next_loudness(sound, next); loudness_sound(int(sound.value))
			BUS_INTERFACE: next_loudness(interface, next); loudness_interface(int(interface.value))
	if next == current_loud:
		pass # stop operation
