extends Node

signal finish_combo(keys: Array)

@onready var mode: Node = $mode
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

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

func finish(sequence: Array) -> void: finish_combo.emit(sequence)

func _input(event: InputEvent) -> void:
	if mode.is_setting():
		mode.manage(get(mode.device_name), event)
