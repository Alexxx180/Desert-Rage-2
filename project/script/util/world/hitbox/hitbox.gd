extends StaticBody2D

signal bash(damage: int)
signal fire(damage: int)

func hit(damage: int) -> void: bash.emit(damage)
func burn(damage: int) -> void: fire.emit(damage)
