extends Node

@onready var board: BehaviorBlackboard = $board
@onready var behavior: BehaviorTree = $behavior
@onready var combo: Timer = $combo

func _ready() -> void:
	combo.timeout.connect(reset_combo)

func reset_combo() -> void:
	board.get_value("combo").query.clear()

func tick() -> void:
	behavior.tick(self, board)
