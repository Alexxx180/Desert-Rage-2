extends OSTLeaf

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].name,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].name,
		"play": func(board: BehaviorBlackboard, ui: Control):
			board.set_value("level", false)
			board.set_value("event", ui.event)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)
