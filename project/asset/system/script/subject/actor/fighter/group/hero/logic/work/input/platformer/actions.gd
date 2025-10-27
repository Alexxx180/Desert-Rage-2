extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $board

# TODOT
func tick() -> void:
	# NO ACTIONS
	pass
	#behavior.tick(self, board)
