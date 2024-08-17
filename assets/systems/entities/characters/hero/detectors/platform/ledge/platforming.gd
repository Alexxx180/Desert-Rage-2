extends Node

var hero: CharacterBody2D
var ledge: Node2D
var distance: Node2D
var on_floor: bool = true

@onready var ledges: Node = $ledges
@onready var checks: Node = $checks

func set_control_entity(body: CharacterBody2D) -> void:
	hero = body
	checks.hero = body
	ledges.hero = hero

func get_ledge_to_jump(i: int, direction: Vector2i) -> bool:
	var jump: bool = false
	var platforms: Array = ledges.data.values()
	while i > 0 and not jump:
		i = i - 1
		ledge = platforms[i]
		jump = checks.can_jump(ledge, direction)
	return jump

func _jump_to_place(next_position: Vector2, is_floor: bool):
	if (is_floor != on_floor):
		hero.processing.movement.process_mode = hero.decide(is_floor)
	on_floor = is_floor
	hero.position = next_position

func perform_jump(direction: Vector2i):
	if get_ledge_to_jump(ledges.size, direction):
		_jump_to_place(ledge.pos, false)
	elif not on_floor:
		distance.detect_floor(direction)

func jump_to_floor(surface: StaticBody2D):
	if distance.floor_detected() and checks.same_floor(hero, surface):
		var target: Vector2 = distance.ray.target_position
		_jump_to_place(hero.position + target, true)
