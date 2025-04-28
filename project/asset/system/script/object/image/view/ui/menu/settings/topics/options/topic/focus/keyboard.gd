extends Node

func set_space(text: String, key: String, mods: Node) -> void:
	text = text.replace(key, "")
	if text.is_valid_int():
		mods.space_trigger.emit(int(text), 10)

func special_focus(key: int, timing: Node) -> void:
	match key:
		KEY_HOME: timing.first.emit()
		KEY_END: timing.last.emit()

func set_focus(event: InputEventKey, focus: Node) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	var key: String = "Ctrl+"
	
	if text.contains(key):
		set_space(text, key, focus.timing.mods)
	elif text.is_valid_int():
		focus.timing.set_focus(int(text))
	else:
		special_focus(event.keycode, focus.timing)
