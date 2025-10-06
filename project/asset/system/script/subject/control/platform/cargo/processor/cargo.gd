extends Node

var platform: CharacterBody2D
var weight: Dictionary = {}
var movement: Callable = Defaults.FUNC

func load_cargo(cargo: CharacterBody2D) -> void:
	if not platform.detectors.ledge.sync_traps(): return
	weight[cargo.get_instance_id()] = cargo
	if weight.size() == 1:
		movement = platform.processor.control_cargo
	disable_collision(cargo)

func free_cargo(cargo: CharacterBody2D) -> void:
	if not platform.detectors.ledge.sync_traps(): return
	weight.erase(cargo.get_instance_id())
	if weight.size() == 0:
		movement = Defaults.FUNC
	enable_collision(cargo)

func toggle_platforming(hero: CharacterBody2D, state: bool) -> void:
	var leap: Node2D = hero.logic.detectors.platforming.platforms.surface.overleap
	leap.turn_monitoring(state)

func disable_mask(gravity) -> Lay:
	return gravity.context(false).collide_main().collide(Lay.BORDERS)

func enable_mask(gravity) -> Lay:
	return gravity.context(true).collide_main()

func disable_collision(cargo: CharacterBody2D) -> void:
	var gravity: Lay = cargo.logic.processors.movement.gravity
	if cargo is PlatformingBox:
		disable_mask(cargo.logic.processors.movement.gravity)
	else:
		disable_mask(cargo.logic.processors.ui.input.gravity).hero_collide(true)
		toggle_platforming(cargo, false)

func enable_collision(cargo: CharacterBody2D) -> void:
	if cargo is PlatformingBox:
		enable_mask(cargo.logic.processors.movement.gravity)
	else:
		enable_mask(cargo.logic.processors.ui.input.gravity)
		toggle_platforming(cargo, true)

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion

func _move_objects(motion: Vector2) -> void:
	_move_certain(platform, motion)
	for cargo in weight.values():
		_move_certain(cargo, motion)

func move_cargo(motion: Vector2) -> void:
	if platform.detectors.ledge.caution.is_colliding():
		_move_certain(platform, Vector2.ZERO)
		#_move_objects(Vector2.ZERO)
	else:
		_move_objects(motion)

func _physics_process(_delta: float) -> void:
	movement.call()
