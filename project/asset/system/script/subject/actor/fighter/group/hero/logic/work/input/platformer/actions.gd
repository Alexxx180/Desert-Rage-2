extends Node

@onready var behavior: BehaviorTree = $behavior

var board: BehaviorBlackboard

# TODOT
func tick() -> void:
	behavior.tick(self, board)
