extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.boss[type]

func tick(mark: Tick) -> int:
	if _ost.theme.set.size() > 0:
		var result = super.tick(mark)
		progress.emit(mark)
		#mark.actor.player.load_music(track)
		return result
	return FAILED
