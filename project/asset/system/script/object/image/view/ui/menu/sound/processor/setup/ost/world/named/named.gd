extends Node # OSTLeaf

@onready var ambient: Node = $ambient

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

func set_types(options: Node, theme: String) -> void:
	ost[theme] = {
		"ui": options.ui.world[theme].name,
		"theme": SoundtrackSystem.user.music.world[theme].name,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[theme])

func set_ost(options: Node) -> void:
	ambient.set_ost(options)
	ost = {}
	for theme in ["rampage", "boss"]:
		ost[theme] = {}
		set_types(options, theme)
