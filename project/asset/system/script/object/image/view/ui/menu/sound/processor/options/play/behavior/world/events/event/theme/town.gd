extends BehaviorActionEvent

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.world.ambient.name.town,
		"ui": options.ui.world.ambient.name.town,
		"progress": progress
	}

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player)
	super.set_track(mark)
