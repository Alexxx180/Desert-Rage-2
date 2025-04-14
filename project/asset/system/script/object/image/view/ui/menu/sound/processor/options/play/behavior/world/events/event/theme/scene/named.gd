extends BehaviorAction

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	var scene: Dictionary = music.world.named.ambient.named.ost.scene
	scene.ui.set[caption].event = event
	_ost = scene.theme

func set_track(player: AudioStreamPlayer) -> void:
	player.load_music(_ost[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.has(caption) and _has_access(_ost[caption]):
		set_track(mark.actor.player)
		return OK
	return FAILED
