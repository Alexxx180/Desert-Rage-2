extends Node

const GAP: int = 32

var floors: Node

func _between(ledge: float, subject: float) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _more(x: float, y: float) -> bool: return x > y
func _less(x: float, y: float) -> bool: return x < y

func _side(axis: int, align: Callable) -> Callable:
	return func(ledge: Vector2) -> bool:
		var state: Variant = floors.state
		if state is CharacterBody2D:
			return align.call(ledge[axis], state.ledge[axis])
		else:
			return align.call(ledge[axis], state.position[axis])

func decide(hero: CharacterBody2D, axis: int) -> Array[Callable]:
	return [
		_side(axis, _between),
		_side(axis, _more),
		_side(axis, _less)
	]
