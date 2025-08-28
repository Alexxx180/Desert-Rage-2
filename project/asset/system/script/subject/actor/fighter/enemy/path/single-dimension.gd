extends Node

@export var speed: int = 200
@export var vertical: bool = false
@onready var hit: Timer = $hit

var paralyzed: bool = false
var direction: float = -1.0
var _motion_path: Callable
var motion: Vector2
var obstacles_counter: int = 0

func update_movement():
	motion = _motion_path.call() # print("MOTION: ", motion)

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

func temporary_freeze() -> void:
	if not paralyzed:
		freeze_motion()
		hit.start()

func paralyze(_body) -> void:
	paralyzed = true
	freeze_motion()

func stop_paralyze(_body) -> void:
	ignite_motion()
	paralyzed = false

func enter_obstacle(_body) -> void:
	obstacles_counter += 1
	if obstacles_counter == 1:
		avoid_obstale()

func exit_obstacle(_body) -> void:
	obstacles_counter -= 1

func avoid_obstale() -> void:
	direction *= -1
	update_movement()
