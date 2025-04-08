extends BehaviorActionEvent

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player, SoundtrackSystem.user.world.boss.name[name])
	super.set_track(mark)
