extends Node

var manage: Node
var input: Node:
	get: return manage.mode.input

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA,
		KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func delete(defaulting: Callable) -> void:
	if input.next.size() > 1:
		input.next.pop_back() # groups = next.size() - 1
		clear(input.next)
		input.reset()
		input.enter()
	else:
		defaulting.call()

func complete(check: String) -> void:
	if input.get(check).call():
		manage.mode.clear()
	else:
		input.finish()

func add(event: InputEvent) -> void:
	if event.is_pressed() and not input.limit():
		input.start_enter()
		input.enter()

func clear(next: Array) -> void:
	var n: Array = next.back()
	n.fill(Defaults.INT)

func nullify(n: Array, i: int = 0): n[i] = Defaults.INT

func add_key(event: InputEvent, check: Callable) -> Callable:
	return func():
		if check.call(event) and not input.limit():
			input.append(event.keycode)
			if input.limit():
				input.finish()
			else:
				input.enter()
			print("INPUT A KEY!!")

func unique(event: InputEvent, deep: bool = false) -> bool:
	return event.is_pressed() and not input.present(event.keycode, deep)

func key_alt(event: InputEvent) -> bool: return true # not event.keycode in hardcoded()

func key_press(event: InputEvent) -> bool:
	return not event.keycode in hardcoded() or not input.empty() # key_alt(event)

func aggregate_next(event: InputEvent) -> Callable:
	return func(): input.enter_next(event.keycode)

func alternate(event: InputEvent, add_keys: Callable, key: String) -> void:
	add_keys.call(event, add_key(event, get(key)), nullify, "key_defined")

func aggregate(event: InputEvent, add_keys: Callable) -> void:
	add_keys.call(event, aggregate_next(event), clear, "agg_undefined")
