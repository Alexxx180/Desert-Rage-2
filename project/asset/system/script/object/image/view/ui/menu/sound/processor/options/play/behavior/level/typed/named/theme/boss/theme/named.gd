extends BehaviorActionPlayback

signal progress(mark: Tick)

var _caption: String

func set_ost(music: Node, caption: String) -> void:
	_caption = caption
	_ost = music.world.named.ost.boss

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[_caption])

func tick(mark: Tick) -> int:
	if _caption != "" and _ost.theme.has(_caption) and _ost.theme[_caption] != "":
		set_track(mark)
		progress.emit(mark)
		# mark.actor.player.load_music(_ost[_caption])
		return OK
	return FAILED
