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
