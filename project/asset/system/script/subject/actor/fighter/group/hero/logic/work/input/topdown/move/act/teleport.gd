extends Node

const ENDED: float = 1.0

@onready var box: CharacterBody2D = Defaults.ENTITY
var hero: CharacterBody2D
var target: Rect2
var reserve: Vector2 = Vector2.ZERO

func set_hero_action(action: String) -> void:
	print("START TELEPORTING: ", target.position + target.size)
	hero.to.moves.set_move_action(action)
	hero.to.moves.set_base_stance("move")
	hero.to.moves.set_jump_start()

func set_box(next: CharacterBody2D) -> void: #if not box is PlatformingBox:
	box = next

func delta(b: Vector2, a: Vector2) -> Vector2: return b - a

func teleport(next: Vector2, action: String = "jump") -> void:
	target = Rect2(hero.position, delta(next, hero.position))
	set_hero_action(action)

func dash(force: Vector2, action: String = "jump") -> void:
	teleport(hero.position + force, action)

func _sync_moving_platform(proportion: float) -> void:
	if box != Defaults.ENTITY:
		hero.position = target.position + delta(box.ledge, target.position) * proportion
	else:
		hero.position = target.position + target.size * proportion

func _jump_from_platform() -> void:
	box.view.remove_child(hero)
	hero.group.add_child(hero)
	hero.position = reserve + target.size
	reserve = Vector2.ZERO

func _jump_to_platform() -> void:
	hero.group.remove_child(hero)
	box.view.add_child(hero)
	reserve = hero.position
	hero.position = box.offset # +  box.position

func move(proportion: float) -> void:
	_sync_moving_platform(proportion)
	if proportion == ENDED:
		if box == Defaults.ENTITY:
			_jump_from_platform()
		else:
			_jump_to_platform()
		print("hero position with 1.0 proportion: ", hero.position)
		hero.to.moves.set_jump_end()
	else:
		print("hero position: ", hero.position)
