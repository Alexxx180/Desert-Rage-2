extends OSTLeaf

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].type,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].type,
		"play": func(board: BehaviorBlackboard):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)
