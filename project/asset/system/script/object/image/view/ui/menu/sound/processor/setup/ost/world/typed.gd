extends OSTLeaf

func set_types(options: Node, theme: String) -> void:
	ost[theme] = {
		"ui": options.ui.world[theme].type,
		"theme": SoundtrackSystem.user.music.world[theme].type,
		"play": func(board: BehaviorBlackboard):
			board.set_value("level", false)
	}
	set_leaf(options, ost[theme])

func set_ost(options: Node) -> void:
	ost = {}
	for theme in ["ambient", "rampage", "boss"]:
		ost[theme] = {}
		set_types(options, theme)
