extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK
