extends Node

const GAP: int = 24

func _between(ledge: float, subject: float) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _more(x: float, y: float) -> bool: return x > y
func _less(x: float, y: float) -> bool: return x < y

func _go(faced: Facing, align: Callable) -> Callable:
	return (func(ledge: Vector2) -> bool:
		return align.call(ledge[faced.axis], faced.subject)
	)

func decide(to: Facing) -> Array[Callable]:
	return [_go(to, _between), _go(to, _more), _go(to, _less)]
