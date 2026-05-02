extends Node

signal move(motion: Vector2)

@onready var mouse: Node = $mouse

@export var fixed: bool = false
@export_group("Keyboard listeners")
@export var left: ActionButtonComplex
@export var right: ActionButtonComplex
@export var forward: ActionButtonComplex
@export var backward: ActionButtonComplex

var manager: ActionsManager = ActionsManager.new()

func get_axis() -> float:
	return manager.power(right, fixed) - manager.power(left, fixed)

func input(_event: InputEvent) -> void: # return # TODO FIXME mouse connect
	if Input.is_action_pressed("mouse_move"):
		mouse.mouse_input()
	elif not mouse.go_for_target:
		move.emit(manager.get_vector(left, right, forward, backward, fixed))
