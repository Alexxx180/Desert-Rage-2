extends Node

const GAP: int = 32

func _between(ledge: float, subject: float) -> bool:
	#print("LEDGE: ", ledge, " - SUBJECT: ", subject)
	return subject >= ledge - GAP and subject <= ledge + GAP

func _more(x: float, y: float) -> bool: return x > y
func _less(x: float, y: float) -> bool: return x < y

func _side(faced: Facing, align: Callable) -> Callable:
	return (func(ledge: Vector2) -> bool:
		return align.call(ledge[faced.axis], faced.subject)
	)

func decide(to: Facing) -> Array[Callable]:
	return [_side(to, _between), _side(to, _more), _side(to, _less)]
