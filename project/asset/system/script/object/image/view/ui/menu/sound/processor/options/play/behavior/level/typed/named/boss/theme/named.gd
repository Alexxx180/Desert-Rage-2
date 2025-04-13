extends BehaviorActionPlayback

var caption: String

func set_ost(music: Node) -> void:
	_ost = music.world.named.boss[caption]

func tick(mark: Tick) -> int:
	var track: String = _ost[caption]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
