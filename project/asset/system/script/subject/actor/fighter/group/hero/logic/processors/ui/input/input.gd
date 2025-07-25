extends Node

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var gravity: Node = $gravity
@onready var actions: BehaviorTree = $actions
@onready var board: BehaviorBlackboard = $board

var axis: int:
	set(value):
		movement.mode.velocity.axis = value
		if axis == 0:
			gravity.turn_walls_collision(false)
			
			movement.mode.velocity.forget_velocity()
			movement.perform_motion(Vector2(_motion.x, 0))
			#movement.perform_motion(Vector2.ZERO)

var _motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func _input(_event: InputEvent) -> void: imitate(_motion)

func imitate(motion: Vector2) -> void:
	if platforming.animation: return
	platforming.perform_jump()
	# """
	# motion.y *= axis
	"""
	if axis == 0:
		motion.y = 0
		if gravity.collision_on:
			gravity.turn_walls_collision(false)
	# """
	movement.perform_motion(motion)
	actions.tick(self, board)
