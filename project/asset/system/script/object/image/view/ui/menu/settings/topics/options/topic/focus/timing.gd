extends Node

signal select(value: int)
signal preview(value: int)
signal first()
signal last()

@onready var finish: Timer = $finish
@onready var action: ActionTimer = $action
@onready var mods: Node = $mods

var MAX: int = 100
var _value: int = 0

func next_digit() -> int: return _value * 10

func set_number(no: int) -> void:
	_value = next_digit() + no
	mods.set_bit(0, false)
	#mods.set_bit(5, false)
	mods.space = 0
	preview.emit(_value)

func start_timers() -> void:
	finish.start()
	action.start()

func set_focus(no: int) -> void:
	if mods.get_bit(0) and next_digit() < MAX:
		set_number(no)
		start_timers()

func _ready() -> void:
	action.timeout.connect(_continue_input)

func _continue_input() -> void:
	action.stop()
	mods.allow_input()

func _reset() -> void:
	print("VALUE: ", _value)
	if _value != 0:
		select.emit(_value)
		_value = 0
