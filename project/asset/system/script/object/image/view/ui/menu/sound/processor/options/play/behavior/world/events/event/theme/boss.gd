extends BehaviorActionEvent

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.world.boss,
		"ui": options.ui.world.boss,
		"progress": progress
	}

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player)
	super.set_track(mark)
