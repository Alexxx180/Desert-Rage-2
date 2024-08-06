extends Node

@onready var hero: CharacterBody2D = get_node("../..")

const JUMP_FORCE = 128
const NEUTRAL = 0
const GAP = 4

func inplace(ledge: float, subject: float) -> bool:
	return ledge >= subject - GAP and ledge <= subject + GAP

func regulation(axis: int) -> Array[Callable]:
	return [
		(func(ledge: Vector2): return inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2): return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2): return ledge[axis] < hero.position[axis])
	]

func check_place(axis: int, direction: Vector2i, ledge: Vector2):
	directions[axis][direction[axis]].call(ledge)

var ledges: Dictionary = {}
var directions: Array[Array] = [
	regulation(Vector2.AXIS_X), regulation(Vector2.AXIS_Y)
]
var y: Array[int] = [NEUTRAL, JUMP_FORCE, -JUMP_FORCE]
var x: Array[int] = [NEUTRAL, JUMP_FORCE, -JUMP_FORCE]

func _jump_to_place(ledge: Node2D, direction: Vector2i):
	if ledge.name == "ledge":
		hero.position = ledge.position
	else:
		hero.position += Vector2(x[direction.x], y[direction.y])

func jump_to(direction: Vector2i):
	if direction == Vector2i.ZERO: return

	var i: int = ledges.size() - 1
	var jump: bool = false

	while i > 0 and not jump:
		i = i - 1
		jump = true
		for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
			jump = jump and check_place(axis, direction, ledges[i].position)

	if jump: _jump_to_place(ledges[i], direction)

func append_ledge(ledge: Node2D): ledges[ledge.get_instance_id()] = ledge
func remove_ledge(ledge: Node2D): ledges.erase(ledge)
