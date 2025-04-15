extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.ost.scene.theme

func tick(mark: Tick) -> int:
	mark.actor.player.load_music(get_track())
	return OK
