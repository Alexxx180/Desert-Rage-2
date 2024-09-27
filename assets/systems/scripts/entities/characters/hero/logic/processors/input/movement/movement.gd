extends Node

signal move(velocity: Vector2)
signal accelerate(mach: int)

enum { WALK = 1, RUN = 2 }

@onready var face: Node = $direction
@onready var feet: Node = $velocity
@onready var behavior: Node = $behavior

var timing: ActionTimer = ActionTimer.new(0.05)
var _walk: bool = true

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		accelerate.emit(WALK)

func _physics_process(delta) -> void:
	move.emit(delta * face.direction * feet.velocity)
	timing.play(delta)
	walk(not _walk)

func _input(_event: InputEvent):
	print("MOVE: ", feet.velocity)
	print("DIRE: ", face.direction)
	behavior.tick(self)
