extends Node

@onready var input: Node
@onready var speed: Node
@onready var mach: Node = $mach

var hero: CharacterBody2D

const increase: Array[int] = [1, 4, 2]

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	speed = hero.stats.speed

func move(delta):
	hero.velocity = input.direction4()
	hero.velocity *= mach.value * speed.value * delta
	hero.move_and_slide()

func _physics_process(delta):
	if (hero.control): move(delta)

func _input(_event: InputEvent):
	if Input.is_action_pressed("run"):
		mach.value = 1
		for plane in [input.x, input.y]:
			mach.value *= plane.axis
		print("CURRENT MACH: ", mach)
