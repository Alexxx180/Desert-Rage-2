extends Node

var hero: CharacterBody2D
var ledge: Node2D

const JUMP_FORCE: int = 128
const NEUTRAL: int = 0

@onready var data: Node = $ledges
@onready var checks: Node = $checks

func _ready():
	hero = get_node("../../../..")
	data.hero = hero
	checks.hero = hero

func _to_floor(direction: Vector2i) -> Vector2:
	var jump: Array[int] = [NEUTRAL, JUMP_FORCE, -JUMP_FORCE]
	return Vector2(jump[direction.x], jump[direction.y])

func _jump_to_place(direction: Vector2i):
	if ledge.name == "ledge":
		print("Jump from : ", hero.position, " To: ", ledge.pos)
		hero.position = ledge.pos
	else:
		print("JUMPED TO FLOOR")
		hero.position += _to_floor(direction)

func get_ledge_to_jump(direction: Vector2i) -> bool:
	var jump: bool = false
	var ledges: Array = data.ledges.values()

	var i: int = data.size
	while i > 0 and not jump:
		i = i - 1
		ledge = ledges[i]
		# print("Iteration: ", i, ", Ledge: ", ledge.name, ", Hero: ", hero.surface.F, " = Floor: ", ledge.F)
		# print(ledge.name)
		if hero.surface.F == ledge.F:
			jump = checks.observe(direction, ledge.pos)

	return jump

func perform_jump(direction: Vector2i):
	if direction != Vector2i.ZERO and get_ledge_to_jump(direction):
		print("JUMPED")
		_jump_to_place(direction)
