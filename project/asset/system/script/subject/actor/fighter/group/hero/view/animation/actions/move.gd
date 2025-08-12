extends Node

@onready var stance: Timer = $stance
@onready var combo: Node = $combo
@onready var jump: Node = $jump

var hero: CharacterBody2D
var tree: AnimationTree:
	get: return hero.view.animation

var go: Array[String] = ["walk", "run"]

func _ready() -> void:
	combo.moves = self
	jump.moves = self

func set_walk_speed(mach: int) -> void: tree.request("go", go[min(mach - 1, 1)])

func set_move_action(stand: String) -> void: tree.request("move", stand)

func set_base_stance(stand: String) -> void:
	for pose in ["hang", "stand"]: tree.request(pose, stand)

func set_aggressive(stand: String) -> void:
	for env in ["ground", "chains"]: tree.request(env, stand)

func set_environment(stand: String) -> void: tree.request("environment", stand)

func set_fighting(stand: String) -> void: combo.fight_body(stand)

func set_fight_start(stand: String) -> void: combo.start_fight(stand)

func set_fight_end() -> void: combo.end_fight()

func set_jump_start() -> void: jump.sequence(true)

func set_jump_end() -> void: jump.stop_dash()

func set_tools(stand: String) -> void: tree.request("tools", stand)
