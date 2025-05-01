extends Node

#signal space_trigger(modifier: int, system: int)

var _modifier: BitMap = BitMap.new()
#var space: int = 0
# var system: int = 4

enum ACTIVE { LEFT = 1, RIGHT = 2 }

func _ready() -> void:
	_modifier.create(Vector2i(6, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, 0)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, 0, bit)

func allow_input() -> void:
	set_bit(0, true)
	#check_spaces()

#func set_space(selection: int, system: int) -> void:
	#space_trigger.emit(selection, system)

"""
func check_spaces() -> void:
	if space != 0:
		space_trigger.emit(space, system)
		space = 0
"""

func get_trigger() -> int:
	if get_bit(ACTIVE.LEFT): return 0
	if get_bit(ACTIVE.RIGHT): return 5
	return -1
