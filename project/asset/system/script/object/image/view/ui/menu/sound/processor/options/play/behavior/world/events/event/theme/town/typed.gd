extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.town

func tick(mark: Tick) -> int:
	mark.actor.player.load_music(get_track())
	return FAILED
