extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

func _determine_track(player: AudioStreamPlayer, ost: Dictionary) -> void:
	if ost.name[name] == "":
		player.load_music(ost.type.set[0])
	else:
		player.load_music(ost.name[name])

func set_track(mark: Tick) -> void:
	set_progress(mark.blackboard)
	var value: int = mark.blackboard.get_value("event")
	mark.blackboard.set_value("event", value + 1)

func tick(mark: Tick) -> int:
	if mark.blackboard.get_value("event") == event:
		set_track(mark)
		return OK
	return FAILED
