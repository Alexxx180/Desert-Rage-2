extends Node

@onready var modes: Node = $modes
@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var gravity: Node = $gravity
@onready var actions: BehaviorTree = $actions
@onready var board: BehaviorBlackboard = $board

var motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func _input(_event: InputEvent) -> void: modes.current.access(motion)

func _physics_process(delta) -> void: modes.current.process_physics(delta)
