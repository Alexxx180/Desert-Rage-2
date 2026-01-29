extends Node

var manage: Node

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA,
		KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func key_defined(n) -> bool: return n.front() == Defaults.INT
func agg_defined() -> bool: return not Defaults.INT in manage.next.front()
func agg_undefined() -> bool: return not agg_defined()
func agg_form(i: int) -> Array: return [i, i, i, i]

func next_key(state: bool, mask: int, next: Callable) -> void:
	if state:
		next.call(manage.next)
		manage.group = mask

func delete(defaulting: Callable) -> void:
	if manage.next.size() > 1:
		manage.next.pop_back() # groups = next.size() - 1
	else:
		defaulting.call(manage.next)

func complete(check: Callable) -> void:
	if check.call(manage.next):
		manage.clear_keys()
	else:
		manage.finish(manage.next)

func add() -> void:
	next_key(agg_defined(), 0, func(n):
		n.append(agg_form(Defaults.INT)))

func clear(next: Array) -> void:
	var n: Array = next[-1]
	for i in len(n): nullify(n, i)

func nullify(n: Array, i: int = 0): n[i] = Defaults.INT

func group_key(event: InputEvent) -> Callable:
	return func(n): n[manage.group] = event.keycode

func add_key(event: InputEvent, check: Callable) -> Callable:
	return func(n): if check.call(event): n.append(event.keycode)

func key_alt(event: InputEvent) -> bool:
	return not event.keycode in hardcoded()

func key_press(event: InputEvent) -> bool:
	return key_alt(event) or manage.next.size() > 0

func aggregate_next(event: InputEvent) -> Callable:
	return func(): next_key(agg_undefined(), 0, group_key(event))

func alternate(event: InputEvent, add_keys: Callable, key: String) -> void:
	add_keys.call(event, func(e): return add_key(e, get(key)), nullify, key_defined)

func aggregate(event: InputEvent, add_keys: Callable) -> void:
	add_keys.call(event, aggregate_next(event), clear, agg_undefined)
