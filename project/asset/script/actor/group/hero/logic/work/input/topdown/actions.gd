extends Timer

@onready var board: BehaviorBlackboard = $board
@onready var named: String = get_node("../../../../..").name

var punch: PackedScene:
	get: return PreloadBus.punch
var kick: PackedScene:
	get: return PreloadBus.kick
var combos: PackedScene:
	get: return PreloadBus.combo

var _behavior: BehaviorTree = null
var behavior: BehaviorTree:# = $behavior
	get: return Works.upload(self, _behavior, LoadBus.actions % named, "behavior")

var combo: Node

func _ready() -> void: timeout.connect(reset_combo)
func reset_combo() -> void: board.g("combo").query.clear()
func tick() -> void: behavior.tick(self, board)
