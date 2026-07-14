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
