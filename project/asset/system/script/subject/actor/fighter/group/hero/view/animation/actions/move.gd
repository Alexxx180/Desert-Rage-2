extends Timer

@onready var combo: ComboMoves = ComboMoves.new(self)
@onready var jump: JumpMoves = JumpMoves.new(self)

var hero: CharacterBody2D
var tree: AnimationTree:
	get: return hero.view.animation

var go: Array[String] = ["walk", "run"]

func _ready() -> void:
	timeout.connect(set_fight_end)
	combo.moves = self
	jump.moves = self

func set_walk_speed(mach: int) -> void: tree.request("go", go[min(mach - 1, 1)])

func set_move_action(stand: String) -> void: tree.request("move", stand)

func set_base_stance(stand: String) -> void:
	for pose in ["hang", "stand"]: tree.request(pose, stand)

func set_aggressive(stand: String) -> void:
	for env in ["ground"]: tree.request(env, stand) # "chains"

func set_environment(stand: String) -> void: tree.request("environment", stand)

func set_hang(stand: String) -> void: tree.request("hang", stand)

func set_hang_move(stand: String) -> void: tree.request("hang_move", stand)

func set_fighting(stand: String) -> void: combo.fight_body(stand)

func set_fight_start(stand: String) -> void: combo.start_fight(stand)

func set_fight_end() -> void: combo.end_fight()

#func set_jump_start() -> void: jump.sequence(true) # tree.effect.sync_animation() # pass # jump.sequence(true)

#func set_jump_end() -> void: jump.end() # print("AYO WHAT THE F")

func set_tools(stand: String) -> void: tree.request("tools", stand)

func nothing() -> void: pass
