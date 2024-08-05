extends Node

var sides: Dictionary

func send_sides(front: Callable, back: Callable):
	sides = { "left": front, "right": back }

func _can_jump(hero: Node2D, box: Vector2) -> bool:
	return sides[hero.direction].call(hero.position.x, box.x)

func jump(hero: Node2D, box: Node2D) -> bool:
	var reach: bool = _can_jump(hero, box.position)
	if reach: hero.position.x = box.position.x
	return reach
