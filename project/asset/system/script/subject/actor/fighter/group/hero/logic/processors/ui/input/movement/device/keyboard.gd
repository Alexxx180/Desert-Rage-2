extends Node

@onready var modes: Node = $modes
@onready var mouse: Node = $mouse

var motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func set_input() -> void:
	modes.current.access(motion)

func _physics_process(delta) -> void:
	mouse.process_input(delta)
	modes.current.process_physics(delta)
