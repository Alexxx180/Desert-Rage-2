extends Node

var input: Node

func c(e: InputEvent) -> int: return e.keycode

func delete(drop: Callable) -> void:
	if input.store.masked():
		input.delete_last()
	else:
		drop.call()

func complete(check: String) -> void:
	if input.store.get(check).call():
		input.stop_operating()
	else:
		input.finish()

func all(event: InputEvent) -> void:
	if input.locked or not input.got_hotkey(event, false):
		input.add() ; input.enter()

func add(event: InputEvent) -> void:
	if event.is_pressed() and not input.store.limit():
		input.start_enter()
		input.enter()

func add_key(code: int, check: Callable, count: String) -> Callable:
	return func(): if check.call(code): input.add_key(code, count) # print("INPUT A KEY!!")

func aggregate_next(code: int) -> Callable:
	return func(): input.enter_next(code)

func _form(check: String, next: Callable, drop: Callable) -> Dictionary:
	return { "add": next, "drop": drop, "check": check }

func alternate(event: InputEvent, key: String, count: String = "MAX", default: String = "nullify") -> Dictionary:
	return _form("is_mask", add_key(c(event), input.store.get(key), count), input.get(default))

func aggregate(event: InputEvent) -> Dictionary:
	return _form("undefined", aggregate_next(c(event)), input.clear_last)
