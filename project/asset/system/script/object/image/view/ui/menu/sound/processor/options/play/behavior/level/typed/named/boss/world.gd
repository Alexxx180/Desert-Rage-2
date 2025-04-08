extends BehaviorAction

func _set_track(mark: Tick) -> void:
	var track: String = SoundtrackSystem.user.world.boss.type.set[0]
	mark.actor.player.load_music(track)

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK
