extends OSTLeaf

@onready var ambient: Node = $ambient

func set_types(options: Node, theme: String) -> void:
	ost[theme] = {
		"ui": options.ui.world[theme].name,
		"theme": SoundtrackSystem.user.music.world[theme].name,
		"play": func(board: BehaviorBlackboard):
			board.set_value("level", false)
	}
	set_leaf(options, ost[theme])

func set_ost(options: Node) -> void:
	ambient.set_ost(options)
	ost = {}
	for theme in ["rampage", "boss"]:
		ost[theme] = {}
		set_types(options, theme)
