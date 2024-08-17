extends Node

const NEUTRAL: int = 0

@onready var combo: Timer = $combo

var hero: CharacterBody2D
var platform: Node
var input: Node

var direction: Vector2i = Vector2i.ZERO

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	platform = hero.detectors.platform.ledge.platforming
	input = hero.processing.input

func _platforming():
	combo.stop()
	if direction == Vector2i.ZERO: return
	platform.perform_jump(direction)
	direction = Vector2.ZERO

func _input(_event):
	if not hero.control: return
	var x: float = input.x.axis
	var y: float = input.y.axis
	if x != NEUTRAL: direction.x = int(x)
	if y != NEUTRAL: direction.y = int(y)
	combo.start() # diagonal jumps support
	# _platforming() # straight jumps only
