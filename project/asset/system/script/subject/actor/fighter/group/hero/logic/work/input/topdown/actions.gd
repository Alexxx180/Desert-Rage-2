extends Timer

@onready var board: BehaviorBlackboard = $board

var punch: PackedScene:
	get: return Defaults.pre.punch
var kick: PackedScene:
	get: return Defaults.pre.kick
var combos: PackedScene:
	get: return Defaults.pre.combos

var _behavior: BehaviorTree = null
var behavior: BehaviorTree:# = $behavior
	get: return Works.upload_tree(self, _behavior, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/input/actions.tscn", "behavior")

var combo: Node

func _ready() -> void: timeout.connect(reset_combo)
func reset_combo() -> void: board.g("combo").query.clear()
func tick() -> void: behavior.tick(self, board)
