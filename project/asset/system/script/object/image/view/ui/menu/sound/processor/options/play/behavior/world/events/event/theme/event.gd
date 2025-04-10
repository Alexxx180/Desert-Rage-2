extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

var _key: String = "event"

func _determine_track(player: AudioStreamPlayer) -> void:
	if _context.name[name] == "":
		player.load_music(_context.type.set[0])
	else:
		player.load_music(_context.name[name])

func set_track(mark: Tick) -> void:
	set_progress(mark.blackboard)
	mark.blackboard.add_value(_key, 1)

func tick(mark: Tick) -> int:
	if mark.blackboard.compare(_key, event):
		set_track(mark)
		return OK
	return FAILED
