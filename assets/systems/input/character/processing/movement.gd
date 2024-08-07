extends Node

@onready var hero: CharacterBody2D = get_node("../..")
@onready var input: Node = get_node("../input")

@export var speed: int = 10000

const increase: Array[int] = [1, 4, 2]
var mach: int = 1

func move(delta):
	hero.velocity = input.direction(input.x, input.y)
	hero.velocity *= mach * speed * delta
	hero.move_and_slide()

func _physics_process(delta):
	if (hero.control): move(delta)

func _input(_event: InputEvent):
	if Input.is_action_pressed("run"):
		mach = increase[input.x] * increase[input.y]
		print("CURRENT MACH: ", mach)
