extends Node

@onready var modes: Node = $modes
@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var gravity: Node = $gravity
@onready var actions: BehaviorTree = $actions
@onready var board: BehaviorBlackboard = $board
@onready var combo: Timer = $combo
@onready var port = get_viewport()

var motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")
var target: Vector2
var mouse: Vector2
var go_for_target: bool = false
var allow_input: bool = true

func check_delta(delta: Vector2, d: int) -> bool:
	#const d: int = 32
	if abs(delta.x) < d and abs(delta.y) < d:
		# print("MOUSE DELTA: ", delta)
		go_for_target = false
		return true
	return false

func resume_input() -> void: allow_input = true
func suspend_input() -> void: allow_input = false

func _input(_event: InputEvent) -> void:
	if not allow_input: return
	# var next: Vector2
	# target = Vector2.ZERO
	"""
	if Input.is_action_just_pressed("mouse_move"):
		go_for_target = true
		mouse = gravity.hero.get_global_mouse_position()
	"""
	#elif go_for_target and Input.is_action_just_released("mouse_move"):
	#	go_for_target = false
	if Input.is_action_pressed("mouse_move"):
		mouse = gravity.hero.get_global_mouse_position()
		# var mouse_delta: Vector2 = pos - gravity.hero.position
		if check_delta(mouse - gravity.hero.position, 32): return
		target = gravity.hero.position.direction_to(mouse)
		modes.current.access(target)
		go_for_target = true
		# next = target
	elif not go_for_target:
		# next = motion
		modes.current.access(motion)
		# target = motion
	# if target != Vector2.ZERO:
	if target != Vector2.ZERO:
		pass
		# print("TARGET MOUSE DIR: ", target)

func _physics_process(delta) -> void:
	if go_for_target:
		# print("TARGET MOUSE DELTA: ", mouse - gravity.hero.position)
		if check_delta(mouse - gravity.hero.position, 32): return
		modes.current.access(target)
	#	if Input.is_action_pressed("mouse_move"):
		#		var direction: Vector2 = target - gravity.hero.position # gravity.hero.position.direction_to(target)
# 		modes.current.access(direction)
	modes.current.process_physics(delta)

func reset_combo() -> void: board.get_value("combo").query.clear()
