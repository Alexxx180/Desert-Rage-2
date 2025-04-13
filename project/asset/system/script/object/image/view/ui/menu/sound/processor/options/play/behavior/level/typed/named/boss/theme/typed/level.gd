extends BehaviorActionPlayback

var type: int = 0

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.boss[type]

func tick(mark: Tick) -> int:
	var track: String = _ost.get_track()
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
