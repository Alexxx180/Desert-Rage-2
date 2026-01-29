extends Node

var manage: Node
@onready var sequence: Node = $sequence

func one_key(_d, event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		manage.mode.clear()
	else:
		manage.finish([event.keycode])

func add_keys(event: InputEvent, add: Callable, defaulting: Callable, check: Callable) -> void:
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(defaulting)
		KEY_ESCAPE: manage.clear_keys()
		KEY_ENTER: sequence.complete(check)
		_: add.call(manage.next)

func alternate(_d, event: InputEvent) -> void:
	sequence.alternate(event, add_keys, "key_alt")

func hot(_d, event: InputEvent) -> void:
	sequence.alternate(event, add_keys, "key_press")

func aggregate(_d, event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add()
		KEY_ESCAPE: manage.clear_keys()
		_: sequence.aggregate(event, add_keys)
