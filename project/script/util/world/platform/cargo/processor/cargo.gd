extends Node

var platform: CharacterBody2D
var weight: Dictionary = {}

func load_cargo(cargo: AnimatableBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight[cargo.get_instance_id()] = cargo
		toggle(cargo, false)

func free_cargo(cargo: CharacterBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight.erase(cargo.get_instance_id())
		toggle(cargo, true)

func toggle_platforming(hero: CharacterBody2D, state: bool) -> void:
	hero.to.platform.surface.border.turn_monitoring(state)

func toggle_mask(gravity, state: bool) -> Lay:
	return gravity.context(state).collide_main().collide(Lay.BORDERS)

func is_weight_box(entity: AnimatableBody2D) -> bool:
	return entity is PlatformingBox

func toggle(cargo: AnimatableBody2D, state: bool) -> void:
	if is_weight_box(cargo):
		toggle_mask(cargo.logic.work.move.gravity, state)
	else:
		toggle_mask(cargo.to.layers, state).hero_collide(true)
		toggle_platforming(cargo, state)

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion

func _move_objects(motion: Vector2) -> void:
	_move_certain(platform, motion)
	for cargo in weight.values():
		_move_certain(cargo, motion)

func move_cargo(motion: Vector2) -> void:
	if platform.see.ledge.caution.is_colliding():
		_move_certain(platform, Vector2.ZERO) #_move_objects(Vector2.ZERO)
	else:
		_move_objects(motion)
