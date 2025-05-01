extends Node

func set_space(text: String, key: String, timing: Node) -> void:
	text = text.replace(key, "")
	if text.is_valid_int():
		timing.set_space(int(text), 10)

func special_focus(key: int, timing: Node) -> void:
	match key:
		KEY_HOME: timing.set_first()
		KEY_END: timing.set_last()

func set_focus(event: InputEventKey, focus: Node) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	var key: String = "Ctrl+"
	var timing: Node = focus.timing
	
	if text.contains(key):
		set_space(text, key, timing)
	elif text.is_valid_int():
		timing.set_focus(int(text))
	else:
		special_focus(event.keycode, timing)
