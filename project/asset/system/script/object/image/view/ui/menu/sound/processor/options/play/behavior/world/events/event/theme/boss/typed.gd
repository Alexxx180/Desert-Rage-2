extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	# mark.actor.player.load_music(get_track())
	return FAILED
