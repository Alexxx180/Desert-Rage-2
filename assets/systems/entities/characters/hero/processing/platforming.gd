extends Node

const NEUTRAL: int = 0
const PERIOD: float = 0.05

@onready var jump: Node = $jump

var hero: CharacterBody2D
var input: Node
var time: float = PERIOD

func set_control_entity(entity: CharacterBody2D) -> void:
	hero = entity
	input = hero.processing.input
	jump.set_control_entity(entity)

func _platforming() -> void:
	var direction: Vector2i = input.direction
	if direction != Vector2i.ZERO:
		jump.perform_jump(direction)

func _physics_process(delta) -> void:
	if (not hero.control): return
	time -= delta
	if time <= NEUTRAL:
		time = PERIOD
		_platforming()
