extends Node

signal move(velocity: Vector2)
signal accelerate(mach: int)

enum { WALK = 1, RUN = 2 }

@onready var face: Node = $motion
@onready var feet: Node = $velocity
@onready var behavior: Node = $behavior
@onready var timing: LazyTimer = $timing

var _walk: bool = true

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		accelerate.emit(WALK)

func _physics_process(delta) -> void:
	move.emit(delta * face.position * feet.velocity)
	walk(not _walk)

func _input(_event: InputEvent):
	behavior.tick(self)
