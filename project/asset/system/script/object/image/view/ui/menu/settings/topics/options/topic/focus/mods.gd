extends Node

signal space_trigger(modifier: int)

var _modifier: BitMap = BitMap.new()
var space: int = 0
var system: int = 4

enum LEFT { ACTIVE = 1, PRESSED = 3 }
enum RIGHT { ACTIVE = 2, PRESSED = 4 }

func _ready() -> void:
	_modifier.create(Vector2i(5, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, 0)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, 0, bit)

func allow_input() -> void:
	set_bit(0, true)
	check_spaces()

func check_spaces() -> void:
	if not get_bit(LEFT.ACTIVE) and get_bit(LEFT.PRESSED):
		space_trigger.emit(3, system)
	elif not get_bit(RIGHT.ACTIVE) and get_bit(RIGHT.PRESSED):
		space_trigger.emit(4, system)
	elif space != 0:
		space_trigger.emit(space, system)
		space = 0
	set_bit(LEFT.PRESSED, 0)
	set_bit(RIGHT.PRESSED, 0)

func get_trigger() -> int:
	if get_bit(LEFT.ACTIVE): return 0
	if get_bit(RIGHT.ACTIVE): return 5
	return -1
