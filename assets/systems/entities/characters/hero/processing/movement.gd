extends Node

var input: Node
var hero: CharacterBody2D

const increase: Array[int] = [1, 4, 2]

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	input = hero.processing.input

func move(delta):
	hero.velocity = hero.stats.run(input) * delta
	hero.move_and_slide()

func _physics_process(delta):
	if (hero.control): move(delta)

func _input(_event: InputEvent):
	if Input.is_action_pressed("run"):
		hero.stats.set_mach(increase, input.x, input.y)
