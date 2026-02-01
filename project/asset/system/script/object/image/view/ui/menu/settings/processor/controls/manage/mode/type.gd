extends Node

signal start_input()
signal interrupt_input()

enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 }

var selected: int = NONE
var separator: String:
	get: return " + " if selected == HOT else ", "

func mask(caption: String, keys: int) -> int:
	if get(caption) == AGG and keys == KEY: return AGG
	return KEY

func listen() -> bool: return selected != NONE

func clear() -> void:
	selected = NONE
	interrupt_input.emit()

func select(value: int) -> void:
	selected = value
	start_input.emit()

func manage(type: Node, event: InputEvent) -> void:
	match selected:
		KEY: type.one_key(event)
		ALT: type.alternate(event)
		HOT: type.hot(event)
		AGG: type.aggregate(event)

func translate(device: Node, sequence: Array) -> Array:
	match selected:
		AGG: return device.translate_agg(sequence)
	return device.translate_alt(sequence)
