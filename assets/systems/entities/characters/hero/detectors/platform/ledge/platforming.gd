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
	ledges.platforming = hero.processing.platforming

func get_ledge_to_jump(direction: Vector2i) -> bool:
	checks.previous = ledge
	var jump: bool = false
	var platform: Array = ledges.data.values()
	for p in platform: print(p.name)
	
	var i: int = ledges.size
	while i > 0 and not jump:
		i = i - 1
		ledge = platform[i]
		jump = checks.can_jump(ledge, direction)
	print("SELECTED: ", ledge.name, " - JUMP? ", jump)
	return jump

func _jump_to_place(next_position: Vector2, is_floor: bool):
	on_floor = is_floor
	hero.position = next_position

func perform_jump(direction: Vector2i):
	if get_ledge_to_jump(direction):
		_jump_to_place(ledge.pos, false)
	elif not on_floor and distance.detect_floor(direction):
		var target: Vector2 = distance.ray.target_position
		_jump_to_place(hero.position + target, true)
