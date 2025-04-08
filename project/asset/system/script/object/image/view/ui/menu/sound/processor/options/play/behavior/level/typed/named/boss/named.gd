extends BehaviorAction

var caption: String

func tick(mark: Tick) -> int:
	var track: String = SoundtrackSystem.user.world.boss.name[caption]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
