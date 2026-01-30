extends Node

@onready var mode: Node = $mode
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

var next: Array = []
var group: int = 0

func reset() -> void:
	next.clear()
	mode.clear()

func clear_keys() -> void: reset()

func a_key(sequence: Array) -> void:
	mode.input_a_key.emit(mode.keys.keyboard.translate_alt(sequence))

func finish(sequence: Array) -> void:
	# match
	mode.finish_combo.emit(mode.keys.keyboard.translate_alt(sequence))
	reset()

func _input(event: InputEvent) -> void:
	if mode.is_setting():
		mode.manage(get(mode.device_name), event)
