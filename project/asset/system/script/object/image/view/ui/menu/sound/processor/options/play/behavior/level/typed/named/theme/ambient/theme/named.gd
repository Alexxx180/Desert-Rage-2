extends BehaviorActionPlayback

var type: int = 0
var caption: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.named.ost[type][caption]

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if mark.blackboard.compare(key, caption):
		mark.actor.player.load_music(get_track()[status])
		mark.blackboard.set_value(key, caption + 1)
		return OK
	return FAILED
