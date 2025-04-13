extends BehaviorActionPlayback

var type: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.theme[type]

func tick(mark: Tick) -> int:
	mark.actor.player.load_music(get_track()[status])
	return OK
