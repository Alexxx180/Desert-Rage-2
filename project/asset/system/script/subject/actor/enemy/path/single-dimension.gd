extends Node

@export var speed: int = 200
@export var vertical: bool = false
@onready var obstacle: Timer = $obstacle

var direction: float = -1.0
var _motion_path: Callable
var motion: Vector2
var obstacles_counter: int = 0

func update_movement():
	motion = _motion_path.call()
	# print("MOTION: ", motion)

func _ready() -> void: ignite_motion()

func ignite_motion() -> void:
	_motion_path = _vertical_motion if vertical else _horizontal_motion
	update_movement()

func freeze_motion() -> void:
	_motion_path = _no_motion
	update_movement()

func _no_motion() -> Vector2: return Vector2.ZERO
func _horizontal_motion() -> Vector2: return Vector2(0, direction * speed)
func _vertical_motion() -> Vector2: return Vector2(direction * speed, 0)

#func _physics_process(_delta: float) -> void:
#	update_movement()

func enter_obstacle(_body) -> void:
	obstacles_counter += 1
	if obstacles_counter == 1:
		avoid_obstale()
	#push_error("OBSTACLES COUNTER: ", obstacles_counter, " - ", _body.name)
	#obstacle.start()

func exit_obstacle(_body) -> void:
	obstacles_counter -= 1
	#push_error("OBSTACLES COUNTER: ", obstacles_counter, " - ", _body.name)

func avoid_obstale() -> void:
	direction *= -1
	update_movement()
