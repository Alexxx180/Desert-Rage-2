extends Node

@onready var modes: Node = $modes
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard

var allow_input: bool = true
func resume_input() -> void: allow_input = true
func suspend_input() -> void: allow_input = false

func _input(_event: InputEvent) -> void:
	if not allow_input: return
	if Input.is_action_pressed("mouse_move"):
		mouse.mouse_input()
	elif not mouse.go_for_target:
		keyboard.set_input()

func _physics_process(delta) -> void:
	mouse.process_input(delta)
	modes.current.process_physics(delta)
