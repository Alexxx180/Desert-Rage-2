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
