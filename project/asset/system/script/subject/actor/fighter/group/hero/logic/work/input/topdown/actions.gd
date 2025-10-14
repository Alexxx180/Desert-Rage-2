extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var combo: Timer = $combo

var board: BehaviorBlackboard

func _ready() -> void:
	combo.timeout.connect(reset_combo)

func reset_combo() -> void:
	board.get_value("combo").query.clear()

func tick() -> void:
	behavior.tick(self, board)
