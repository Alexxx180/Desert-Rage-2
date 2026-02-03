extends Node

@onready var sequence: Node = $sequence

func one_key(event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		sequence.manage.mode.clear()
	else:
		sequence.manage.finish([event.keycode])

func add_keys(event: InputEvent, op: Dictionary) -> void:
	print("KEYCODE: ", event.keycode, " - Is: ", event.keycode == KEY_BACKSPACE)
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(op.defaulting)
		KEY_ESCAPE: sequence.clear_keys()
		KEY_ENTER: sequence.complete(op.check)
		_: op.add.call()

func _alt(state: bool, event: InputEvent, type: String, count: String = "MAX", default: String = "nullify") -> void:
	if state: add_keys(event, sequence.alternate(event, "key_" + type, count, default))

func _agg(state: bool, event: InputEvent) -> void:
	if state: add_keys(event, sequence.aggregate(event))

func _lock() -> bool:
	sequence.input.locked = true
	return true

func _all(event: InputEvent) -> void:
	if sequence.input.got_hotkey(event): return
	if sequence.input.hotkeys(event.keycode): return
	
	var state: bool = not sequence.input.present(event.keycode, true)
	_alt(state, event, "hold", "key_mask", "delete_last")

func alternate(event: InputEvent) -> void:
	_alt(sequence.input.unique(event), event, "alt")

func hot(event: InputEvent) -> void:
	if event.is_pressed():
		_alt(not sequence.input.present(event.keycode), event, "press")
	else:
		sequence.input.finish()

func aggregate(event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add(event)
		_: _agg(sequence.unique(event, true), event)

func all(event: InputEvent) -> void:
	match event.keycode:
		KEY_BACKSPACE: if event.is_pressed(): sequence.input.remove_last()
		KEY_COMMA: sequence.all(event)
		KEY_ENTER: pass
		_: _all(event)
