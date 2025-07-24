extends Node

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var gravity: Node = $gravity
@onready var actions: BehaviorTree = $actions
@onready var board: BehaviorBlackboard = $board

var axis: int = 1

var _motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func _input(_event: InputEvent) -> void: imitate(_motion)

func imitate(motion: Vector2) -> void:
	if platforming.animation: return
	platforming.perform_jump()
	motion.y *= axis
	movement.perform_motion(motion)
	actions.tick(self, board)
