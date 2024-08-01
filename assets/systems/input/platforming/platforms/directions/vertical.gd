extends "res://assets/systems/input/platforming/platforms/directions/horizontal.gd"

func ledge(side: Callable, hero: Node2D, box: Node2D) -> bool:
	var can_jump: bool = side.call(hero.position.y, box.position.y)
	if can_jump: hero.position.y = box.position.y
	return can_jump
