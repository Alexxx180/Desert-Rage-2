extends BehaviorAction

signal progress(mark: Tick)

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	_ost = music.world.named.ambient.named.ost.scene
	_ost.ui.set[caption].event.id = event

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.has(caption) and _has_access(_ost[caption]):
		set_track(mark)
		progress.emit(mark)
		return OK
	return FAILED
