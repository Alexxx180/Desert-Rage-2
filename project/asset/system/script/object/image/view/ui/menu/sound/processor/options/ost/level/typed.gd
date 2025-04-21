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
