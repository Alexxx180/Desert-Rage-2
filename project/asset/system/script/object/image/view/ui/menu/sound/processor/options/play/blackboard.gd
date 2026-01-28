extends BehaviorBlackboard

signal progress(value: int)

enum { START = 0, RAMPAGE = 6 } #var _rampage: int = 0 #const LEVEL: int = 4

func reset() -> void:
	s("level", true).s("level_type", START).s("level_name", START)
	s("level_rampage", START).s("rampage", START).s("event", START)
	# set_value("level_event", Vector2i(0, 0)) - TODO level events support
	# x = store first event * LEVEL, y = + rest events
	update_progress()

func update_progress() -> void:
	var event: int = g("event") * RAMPAGE
	var value: int = event + g("rampage") + g("level_rampage")
	progress.emit(value)
