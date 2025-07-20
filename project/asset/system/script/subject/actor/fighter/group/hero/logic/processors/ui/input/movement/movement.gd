extends Node

signal moving(velocity: Vector2)
signal controlling(velocity: Vector2)
signal move(velocity: Vector2)
signal accelerate(mach: int)

enum { WALK = 1, RUN = 2 }

@onready var face: Node = $motion
@onready var behavior: Node = $behavior
@onready var timing: LazyTimer = $timing
@onready var mode: Node = $mode

var _walk: bool = true
var motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		accelerate.emit(WALK)

func _physics_process(delta) -> void:
	move.emit(delta * face.position)
	walk(not _walk)

func perform_motion() -> void:
	imitate_motion(motion)
	controlling.emit(motion)
	behavior.tick(self)

func imitate_motion(target_motion: Vector2) -> void:
	moving.emit(target_motion)
