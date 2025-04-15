extends BehaviorBlackboard

signal progress(value: int)

const RAMPAGE: int = 6
const LEVEL: int = 4

func reset() -> void:
	set_value("level", true)
	set_value("level_type", 0)
	set_value("level_name", 0)
	set_value("event", 0)
	set_value("rampage", 0)

func update_progress() -> void:
	var event: int = get_value("event")
	var value: int = event * RAMPAGE + get_value("rampage")
	if not get_value("level"):
		value += LEVEL
	progress.emit(value)
