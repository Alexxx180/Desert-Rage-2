extends Node

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var gravity: Node = $gravity
@onready var actions: BehaviorTree = $actions
@onready var board: BehaviorBlackboard = $board

func _input(_event: InputEvent) -> void:
	if platforming.animation: return
	platforming.perform_jump()
	movement.perform_motion()
	actions.tick(self, board)
