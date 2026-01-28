extends Node

signal finish_combo(keys: Array)

@onready var mode: Node = $mode

var previous: Array = Defaults.ARRAY
var next: Array
var groups: int = 0

func make_mask() -> void: next = previous.duplicate()
func save_state(keys: Array) -> void:
	previous = keys
	make_mask()

func clear_keys() -> void:
	make_mask()
	mode.clear()

func _input(event: InputEvent) -> void: mode.manage(self, event)

func one_key(_d, event: InputEvent) -> void:
	if event.keycode in [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA]:
		mode.clear()
	else:
		finish_combo.emit([event.keycode])

func alternate(d, event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: groups = previous.size() + 1
		KEY_BACKSPACE: groups = next.size() - 1
		KEY_ESCAPE: pass
		KEY_ENTER: groups = previous.size()
	previous.append()
	finish_combo.emit()
	
	select_type(ALT)
func aggregate() -> void:
	key_mask = AGG
	select_type(AGG)
	key_mask = KEY
