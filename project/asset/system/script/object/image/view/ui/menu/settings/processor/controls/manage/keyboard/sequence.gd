extends Node

var manage: Node
var input: Node:
	get: return manage.mode.input

const FIRST: int = 0

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA,
		KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func delete(defaulting: Callable) -> void:
	if input.next.size() > 1:
		input.delete_last()
	else:
		defaulting.call()

func complete(check: String) -> void:
	if input.get(check).call():
		manage.mode.clear()
	else:
		input.finish()

func all(event: InputEvent) -> void:
	if not input.locked: return
	
	if event.is_pressed(): # and not input.limit():
		input.append([])
		input.enter()
	else:
		input.locked = false

func add(event: InputEvent) -> void:
	if event.is_pressed() and not input.limit():
		input.start_enter()
		input.enter()

func add_key(event: InputEvent, check: Callable, count: String) -> Callable:
	return func(): if check.call(event): input.add_key(event.keycode, input.get(count)) # print("INPUT A KEY!!")

func unique(event: InputEvent, deep: bool = false) -> bool:
	return event.is_pressed() and not input.present(event.keycode, deep)

func key_hold(event: InputEvent) -> bool:
	return not event.keycode in hardcoded() or not input.empty()

func key_alt(event: InputEvent) -> bool: return not input.limit() # not event.keycode in hardcoded()

func key_press(event: InputEvent) -> bool: return key_hold(event) and key_alt(event)

func aggregate_next(event: InputEvent) -> Callable:
	return func(): input.enter_next(event.keycode)

func alternate(event: InputEvent, key: String, count: String = "MAX", default: String = "nullify") -> Dictionary:
	return { "add": add_key(event, get(key), count), "check": "key_defined",
		"defaulting": input.get(default) }

func aggregate(event: InputEvent) -> Dictionary:
	return { "add": aggregate_next(event), "check": "agg_undefined",
		"defaulting": input.clear_last }
