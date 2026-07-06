class_name MouseManualControl extends Node

const GAP_ZONE: int = 32

var mouse_target: Rect2
var go_for_target: bool = false
var act: Node
var hero: CharacterBody2D

func get_delta() -> Vector2: return mouse_target.position - hero.position

func is_near_gap(delta: Vector2) -> bool:
	return abs(delta.x) < GAP_ZONE and abs(delta.y) < GAP_ZONE

func get_direction() -> Vector2:
	return hero.position.direction_to(mouse_target.position)

func near_target() -> bool:
	var is_near: bool = is_near_gap(get_delta())
	if is_near: go_for_target = false
	return is_near

func go_to_target() -> void:
	act.turn_around(mouse_target.size)
	go_for_target = true

func mouse_input() -> void:
	mouse_target.position = hero.get_global_mouse_position()
	if not near_target():
		mouse_target.size = get_direction()
		go_to_target()

func process_input(_delta: float) -> void:
	if go_for_target and near_target():
		go_to_target()
