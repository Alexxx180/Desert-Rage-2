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
