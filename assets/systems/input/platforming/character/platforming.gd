extends Node

var hero: CharacterBody2D
var ledge: Node2D

const JUMP_FORCE: int = 128
const NEUTRAL: int = 0

@onready var data: Node = $ledges
@onready var checks: Node = $checks
@onready var detector = get_node("../shape")

var target: Vector2

func set_hero(body: CharacterBody2D):
	hero = body
	data.hero = body
	checks.hero = body

func _jump_to_place(direction: Vector2i):
	if ledge.name == "ledge":
		# print("Jump from : ", hero.position, " To: ", ledge.pos)
		hero.position = ledge.pos
	else:
		print("JUMPED TO FLOOR")
		hero.position += target

func _targeting(direction: Vector2i) -> void:
	target = detector.shape.size / 2
	target.x *= direction.x
	target.y *= direction.y

func get_ledge_to_jump(direction: Vector2i) -> bool:
	var jump: bool = false
	var ledges: Array = data.ledges.values()
	var desc: String = "LEDGES: "
	for l in ledges:
		desc += l.name + ": " + str(l.F) + ", "
	print(desc)
	var previous: Node2D = ledge

	var i: int = data.size
	while i > 0 and not jump:
		i = i - 1
		ledge = ledges[i]
		# print("Iteration: ", i, ", Ledge: ", ledge.name, ", Hero: ", hero.surface.F, " = Floor: ", ledge.F)
		# print(ledge.name)
		if hero.surface.F == ledge.F:
			var pos: Vector2 = ledge.pos
			if pos == Vector2.ZERO:
				pos = hero.position + _targeting(direction)
				print("FLOOR FOUND! POS: ", pos)
				print("HERO POS: ", hero.position)
			jump = not previous == ledge and checks.observe(direction, pos)
			# jump = checks.observe(direction, ledge.pos)
	print("SELECTED: ", ledge.name, " - JUMP? ", jump)

	return jump

func perform_jump(direction: Vector2i):
	if get_ledge_to_jump(direction):
		# print("JUMPED")
		_jump_to_place(direction)
