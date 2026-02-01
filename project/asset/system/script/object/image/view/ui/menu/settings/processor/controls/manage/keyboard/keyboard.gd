extends Node

@onready var sequence: Node = $sequence

func one_key(event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		sequence.manage.mode.clear()
	else:
		sequence.manage.finish([event.keycode])

func add_keys(event: InputEvent, add: Callable, defaulting: Callable, check: String) -> void:
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(defaulting)
		KEY_ESCAPE: sequence.clear_keys()
		KEY_ENTER: sequence.complete(check)
		_: add.call()

func _alt(state: bool, event: InputEvent, type: String) -> void:
	if state: sequence.alternate(event, add_keys, "key_" + type)

func _agg(state: bool, event: InputEvent) -> void:
	if state: sequence.aggregate(event, add_keys)

func alternate(event: InputEvent) -> void:
	_alt(sequence.unique(event), event, "alt")

func hot(event: InputEvent) -> void:
	if event.is_pressed():
		_alt(not sequence.input.present(event.keycode), event, "press")
	else:
		sequence.input.finish()

func aggregate(event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add(event)
		KEY_ESCAPE: sequence.clear_keys()
		_: _agg(sequence.unique(event, true), event)
