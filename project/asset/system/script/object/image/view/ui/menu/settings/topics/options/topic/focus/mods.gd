extends Node

signal space_trigger(modifier: int)

var _modifier: BitMap = BitMap.new()
var space: int = 0
var system: int = 4

enum LEFT { ACTIVE = 1, PRESSED = 3 }
enum RIGHT { ACTIVE = 2, PRESSED = 4 }

func _ready() -> void:
	_modifier.create(Vector2i(6, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, 0)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, 0, bit)

func allow_input() -> void:
	set_bit(0, true)
	check_spaces()

func check_spaces() -> void:
	"""
	print("LEFT: active - ", get_bit(LEFT.ACTIVE), ", PRESSED - ", get_bit(LEFT.PRESSED))
	print("RIGHT: active - ", get_bit(RIGHT.ACTIVE), ", PRESSED - ", get_bit(RIGHT.PRESSED))
	if get_bit(5):
		if get_bit(LEFT.PRESSED): # not get_bit(LEFT.ACTIVE) and 
			space_trigger.emit(3, system)
			set_bit(LEFT.PRESSED, 0)
		elif get_bit(RIGHT.PRESSED): # not get_bit(RIGHT.ACTIVE) and 
			space_trigger.emit(4, system)
			set_bit(RIGHT.PRESSED, 0)
	"""
	if space != 0:
		space_trigger.emit(space, system)
		space = 0

func get_trigger() -> int:
	if get_bit(LEFT.ACTIVE): return 0
	if get_bit(RIGHT.ACTIVE): return 5
	return -1
