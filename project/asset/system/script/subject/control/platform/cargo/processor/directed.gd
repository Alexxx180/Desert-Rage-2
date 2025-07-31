extends Node

@export var direction: Vector2 = Vector2(250, 0)
const INVERSE: Vector2 = Vector2(-1, -1)

var platform: CharacterBody2D
var weight: Dictionary = {}
var movement: Callable = Defaults.FUNC

func load_cargo(box: CharacterBody2D) -> void:
	weight[box.get_instance_id()] = box
	print("LOAD CARGO")
	box.logic.processors.ui.input.gravity.turn_walls_collision(false, false, true)
	if weight.size() == 1:
		movement = _control_cargo

func free_cargo(box: CharacterBody2D) -> void:
	weight.erase(box.get_instance_id())
	print("FREE CARGO")
	box.logic.processors.ui.input.gravity.turn_walls_collision(true)
	if weight.size() == 0:
		movement = Defaults.FUNC

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion
	box.move_and_slide()

func _move_cargo(motion: Vector2) -> void:
	_move_certain(platform, motion)
	for cargo in weight.values():
		_move_certain(cargo, motion)

func _control_cargo() -> void:
	var motion: Vector2 = platform.detectors.ledge.move()
	#print("TRYING CONTROL: ", motion)
	if motion != Vector2.ZERO:
		#print("CARGO CONTROL: ", motion)
		_move_cargo(direction)

func change_direction() -> void:
	direction *= INVERSE

func _physics_process(_delta: float) -> void:
	movement.call()
