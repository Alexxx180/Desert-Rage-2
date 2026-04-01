extends Node

@onready var board: BehaviorBlackboard = $board
@onready var timer: Timer = $combo

@onready var punch = preload("res://asset/system/scene/subject/particle/fight/punch.tscn")
@onready var kick = preload("res://asset/system/scene/subject/particle/fight/kick.tscn")
@onready var combos = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/status/markers/combo.tscn")

var _behavior: BehaviorTree = null
var behavior: BehaviorTree:# = $behavior
	get: return Works.upload_tree(self, _behavior, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/input/actions.tscn", "behavior")

var combo: Node

func _ready() -> void:
	timer.timeout.connect(reset_combo)

func reset_combo() -> void:
	board.g("combo").query.clear()

func tick() -> void:
	behavior.tick(self, board)
