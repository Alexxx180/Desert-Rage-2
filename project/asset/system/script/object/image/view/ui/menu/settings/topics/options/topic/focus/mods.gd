extends Node

signal space_trigger(modifier: int)

var _modifier: BitMap = BitMap.new()
var space: int = 0

enum { BIT_ARRAY = 0, LEFT = 1, RIGHT = 2 }

func _ready() -> void:
	_modifier.create(Vector2i(4, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, BIT_ARRAY)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, BIT_ARRAY, bit)

func allow_input() -> void: set_bit(0, true)

func check_triggers() -> void:
	if get_bit(LEFT):
		space_trigger.emit(3)
		set_bit(LEFT, 0)
	elif get_bit(RIGHT):
		space_trigger.emit(4)
		set_bit(RIGHT, 0)
	else:
		space_trigger.emit(space)

func get_trigger() -> int:
	if get_bit(LEFT): return 0
	if get_bit(RIGHT): return 5
	return -1
