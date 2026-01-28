extends Node

signal finish_combo(keys: Array)

@onready var mode: Node = $mode

var previous: Array = Defaults.ARRAY
var next: Array
var group: int = 0

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

func add_keys(event: InputEvent, add: Callable, defaulting: Callable, check: Callable) -> void:
	match event.keycode:
		KEY_BACKSPACE:
			if next.size() > 1:
				next.pop_back() # groups = next.size() - 1
			else:
				defaulting.call()
		KEY_ESCAPE: clear_keys()
		KEY_ENTER:
			if check.call(): # next.front() != Defaults.INT:
				clear_keys()
			else:
				finish_combo.emit(next)
		_: add.call()

func alternate(d, event: InputEvent) -> void:
	add_keys(event, func(): next.append(event.keycode), 
		func(): next[0] = Defaults.INT,
		func(): next.front() == Defaults.INT)

func agg_form(i: int) -> Array: return [i, i, i, i]
func agg_undefined() -> bool: return Defaults.INT in next.front()

func hot(d, event: InputEvent) -> void:
	alternate(d, event)

func aggregate(d, event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA:
			if not agg_undefined():
				next.append(agg_form(Defaults.INT))
				group = 0
		KEY_ESCAPE: clear_keys()
		_: add_keys(event, func():
			if agg_undefined():
				next[group] = event.keycode
				group += 1,
			func(): for i in len(next[-1]): next[-1][i] = Defaults.INT,
			agg_undefined)
