extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.theme[type]

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)
