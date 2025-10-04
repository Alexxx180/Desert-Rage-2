extends Node

@onready var device: Node = get_parent()

const GAP_ZONE: int = 32
var hero: CharacterBody2D
var mouse_target: Rect2
var go_for_target: bool = false

func near_target() -> bool:
	var delta: Vector2 = mouse_target.position - hero.position
	if abs(delta.x) < GAP_ZONE and abs(delta.y) < GAP_ZONE:
		go_for_target = false
		return true
	return false

func go_to_target() -> void:
	device.modes.current.access(mouse_target.size)
	go_for_target = true

func mouse_input() -> void:
	mouse_target.position = hero.get_global_mouse_position()
	if not near_target():
		mouse_target.size = hero.position.direction_to(mouse_target.position)
		go_to_target()

func process_input(_delta: float) -> void:
	if go_for_target and near_target():
		go_to_target()
