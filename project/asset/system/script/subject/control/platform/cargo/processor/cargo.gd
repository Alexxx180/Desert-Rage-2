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
	leap.upland.monitoring = state
	leap.gap.monitoring = state

func disable_collision(cargo: CharacterBody2D) -> void:
	if cargo is PlatformingBox:
		cargo.logic.processors.movement.gravity.turn_walls_collision(false, false)
	else:
		cargo.logic.processors.ui.input.gravity.turn_walls_collision(false, false, true)
		toggle_platforming(cargo, false)

func enable_collision(cargo: CharacterBody2D) -> void:
	if cargo is PlatformingBox:
		cargo.logic.processors.movement.gravity.turn_walls_collision(true)
	else:
		cargo.logic.processors.ui.input.gravity.turn_walls_collision(true)
		toggle_platforming(cargo, true)

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion
	box.move_and_slide()

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
