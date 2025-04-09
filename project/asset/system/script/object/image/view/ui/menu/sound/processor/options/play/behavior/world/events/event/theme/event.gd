extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

var _key: String = "event"

func _determine_track(player: AudioStreamPlayer, ost: Dictionary) -> void:
	if ost.name[name] == "":
		player.load_music(ost.type.set[0])
	else:
		player.load_music(ost.name[name])

func set_track(mark: Tick) -> void:
	set_progress(mark.blackboard)
	mark.blackboard.add_value(_key, 1)

func tick(mark: Tick) -> int:
	if mark.blackboard.compare(_key, event):
		set_track(mark)
		return OK
	return FAILED
