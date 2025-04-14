extends BehaviorActionPlayback

var _caption: String

func set_ost(music: Node, caption: String) -> void:
	_caption = caption
	_ost = music.world.named.ost.boss.theme

func tick(mark: Tick) -> int:
	if _caption != "" and _ost[_caption] != "":
		mark.actor.player.load_music(_ost[_caption])
		return OK
	return FAILED
