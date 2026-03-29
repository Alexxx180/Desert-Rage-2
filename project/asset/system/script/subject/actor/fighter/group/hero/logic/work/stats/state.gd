extends Node

enum { STANDING }

@onready var bits: Node = $bits

func get_value(no: int) -> bool: return bits.get_value(no)
func set_value(no: int, next: bool) -> void: bits.set_value(no, next)
func switch(no: int, next: int) -> bool: return bits.switch(no, next)

func is_standing() -> bool: return get_value(STANDING)
func standing_to(next: bool) -> void: set_value(STANDING, next)
