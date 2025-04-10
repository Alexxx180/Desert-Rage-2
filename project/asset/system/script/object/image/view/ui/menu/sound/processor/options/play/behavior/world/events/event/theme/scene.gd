extends BehaviorActionEvent

func get_context(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.world.ambient.name.scene,
		"ui": options.ui.world.ambient.name.scene
	}

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player)
	super.set_track(mark)
