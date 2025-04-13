extends OSTLeaf

func set_types(options: Node, types: Array[String], theme: String, i: int) -> void:
	ost[theme][i] = {
		"ui": options.ui.level[types[i]].type[theme],
		"theme": SoundtrackSystem.user.music.level[types[i]].type[theme],
		"play": func(board: BehaviorBlackboard):
			board.set_value("level", true)
			board.set_value("level_type", i)
	}
	set_leaf(options, ost[theme][i])

func set_ost(options: Node) -> void:
	ost = {}
	var types: Array[String] = AmbientOST.get_level_types()
	var size: int = types.size()
	for theme in ["theme", "boss"]:
		ost[theme] = {}
		var i: int = size
		while i > 0:
			i -= 1
			set_types(options, types, theme, i)
