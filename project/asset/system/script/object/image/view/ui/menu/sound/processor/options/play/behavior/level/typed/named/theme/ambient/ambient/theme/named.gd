extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var caption: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.named.ost[type][caption]
	#_ost.ui.set[0].get_node("../../head/mix").safe_connect(_ost)

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if _ost.theme.has("mix") and _ost.theme.mix and mark.blackboard.compare(key, caption):
		# mark.actor.player.load_music(get_track(status))
		mark.blackboard.set_value(key, caption + 1)
		return super.tick(mark)
	return FAILED
