class_name BitField extends Node

var settings: int

func zeros(a: int, no: int) -> int: return a << no
func digit(no: int) -> int: return 2 ** no

func switch(no: int, next: int) -> bool:
	set_value(no, next)
	return get_value(no)

func get_value(no: int) -> bool: return Bits.out(settings, no)
func set_value(no: int, next: bool) -> void:
	var state: int = digit(no)
	settings = settings & ~state | (state * int(next)) 
