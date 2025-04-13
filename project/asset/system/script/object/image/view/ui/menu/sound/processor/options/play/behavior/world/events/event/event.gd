extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

var _key: String = "event"

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_event_theme(context.duplicate())

func _determine_track(player: AudioStreamPlayer) -> void:
	if _ost.name[name] == "":
		player.load_music(_ost.type.set[0])
	else:
		player.load_music(_ost.name[name])

func set_track(mark: Tick) -> void:
	set_progress(mark.blackboard)
	mark.blackboard.add_value(_key, 1)

func tick(mark: Tick) -> int:
	if mark.blackboard.compare(_key, event):
		set_track(mark)
		return OK
	return FAILED
