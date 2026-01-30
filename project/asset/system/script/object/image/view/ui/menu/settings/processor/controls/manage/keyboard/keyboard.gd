extends Node

@onready var sequence: Node = $sequence

func one_key(event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		sequence.manage.mode.clear()
	else:
		sequence.manage.finish([event.keycode])

func add_keys(event: InputEvent, add: Callable, defaulting: Callable, check: Callable) -> void:
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(defaulting)
		KEY_ESCAPE: sequence.clear_keys()
		KEY_ENTER: sequence.complete(check)
		_: add.call(sequence.manage.next)

func alternate(event: InputEvent) -> void:
	if event.is_pressed() and not sequence.present(event):
		sequence.alternate(event, add_keys, "key_alt")

func hot(event: InputEvent) -> void:
	if event.is_pressed():
		if not sequence.present(event):
			sequence.alternate(event, add_keys, "key_press")
	else:
		sequence.manage.finish(sequence.manage.next)

func aggregate(event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add()
		KEY_ESCAPE: sequence.clear_keys()
		_: sequence.aggregate(event, add_keys)
