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

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		accelerate.emit(WALK)

func _physics_process(delta) -> void:
	move.emit(delta * face.position)
	walk(not _walk)

func perform_motion(target_motion: Vector2) -> void:
	moving.emit(target_motion)
	face.set_position(target_motion)
	# controlling.emit(motion)
	behavior.tick(self)
