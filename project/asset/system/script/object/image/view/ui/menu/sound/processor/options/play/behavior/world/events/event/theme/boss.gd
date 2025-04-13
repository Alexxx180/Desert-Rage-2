extends BehaviorActionEvent

func get_context(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.music.world.boss,
		"ui": options.ui.world.boss.set
	}

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player)
	super.set_track(mark)
