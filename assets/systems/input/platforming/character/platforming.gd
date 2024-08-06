extends Node

var hero: CharacterBody2D

const JUMP_FORCE: int = 128
const NEUTRAL: int = 0

@onready var data: Node = $ledges
@onready var checks: Node = $checks

func _ready():
	hero = get_node("../../../..")
	data.hero = hero

func _to_floor(direction: Vector2i) -> Vector2:
	var jump: Array[int] = [NEUTRAL, JUMP_FORCE, -JUMP_FORCE]
	return Vector2(jump[direction.x], jump[direction.y])

func _jump_to_place(ledge: Node2D, direction: Vector2i):
	hero.position = (ledge.position if ledge.name
		== "ledge" else _to_floor(direction))

func perform_jump(direction: Vector2i):
	if direction == Vector2i.ZERO: return

	var i: int = data.size - 1
	var jump: bool = false
	var ledges: Array[Node2D] = data.ledges.values()

	while i >= 0 and not jump:
		i = i - 1
		jump = true
		for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
			jump = jump and checks.observe(axis, direction, ledges[i])

	if jump: _jump_to_place(ledges[i], direction)
