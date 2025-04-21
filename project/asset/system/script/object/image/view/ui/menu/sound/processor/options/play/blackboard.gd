extends BehaviorBlackboard

signal progress(value: int)

const RAMPAGE: int = 6
#var _rampage: int = 0
#const LEVEL: int = 4

func reset() -> void:
	set_value("level", true)
	set_value("level_type", 0)
	set_value("level_name", 0)
	set_value("level_rampage", 0)
	# set_value("level_event", Vector2i(0, 0)) - TODO level events support
	# x = store first event * LEVEL, y = + rest events
	set_value("rampage", 0)
	set_value("event", 0)
	update_progress()

func update_progress() -> void:
	var event: int = get_value("event") * RAMPAGE
	var value: int = event + get_value("rampage") + get_value("level_rampage")
	progress.emit(value)
