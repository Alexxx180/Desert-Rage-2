extends Node

const PERIOD: float = 0.05

var input: Node
var hero: CharacterBody2D
var time: float = 0

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	input = hero.processing.input

func move(delta):
	hero.velocity = hero.stats.run(input) * delta
	hero.move_and_slide()
	if time > 0: time -= delta

func _physics_process(delta):
	if (hero.control):
		move(delta)
		if (hero.velocity == Vector2.ZERO):
			hero.stats.mach.value = 1

func _input(_event: InputEvent):
	var hold = Input.is_action_pressed("run")
	var toggle = Input.is_action_just_pressed("run")

	if toggle:
		time = PERIOD
	elif Input.is_action_just_released("run") and time > 0:
		time = 0
		hero.stats.mach.value = 1

	if hold: hero.stats.mach.value = 2
