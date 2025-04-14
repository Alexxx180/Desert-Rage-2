extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

var _key: String = "event"

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_event_theme(context.duplicate())

func set_track(player: AudioStreamPlayer) -> void:
	player.load_music(get_track())

func tick(mark: Tick) -> int:
	if mark.blackboard.compare(_key, event):
		set_progress(mark.blackboard)
		mark.blackboard.add_value(_key, 1)
		set_track(mark.actor.player)
		return OK
	return FAILED
