extends StaticBody2D

signal hit(damage: int)
signal burn(damage: int)

func bash(damage: int) -> void: hit.emit(damage)
func fire(damage: int) -> void: burn.emit(damage)
