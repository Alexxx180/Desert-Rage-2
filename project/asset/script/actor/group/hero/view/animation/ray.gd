extends AdvancedCharacterAnimation

@onready var moves: Node = $moves
@onready var effect: Node = $effect # @onready var syncer: Node = $syncer

const unique: PackedStringArray = ["whip_dash", "fire", "whip", "hang_whip_dash"]

func _ready() -> void:
	direct()
	effect.moves = moves
	# timeout.connect(set_fight_end)
	# syncer.moves = moves

func direct() -> void:
	super.direct()
	for animation in unique: blend(animation)
	if not Input.is_action_pressed("action"): blend("pull_forward")

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: moves.set_base_stance("move")
	else: moves.set_base_stance("idle")
	return turned

@onready var combo: ComboMoves = ComboMoves.new(self)
@onready var jump: JumpMoves = JumpMoves.new(self)

var hero: CharacterBody2D
var tree: AnimationTree:
	get: return hero.view.animation

var go: Array[String] = ["walk", "run"]

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

signal sync_anim(animation: String, frame: int)

enum { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3 }

func set_damage(multiplier: float = 1) -> void:
	HUD.level.fight.close_damage(HUD.hero) # * multiplier) # 5

func set_position(proportion: float) -> void:
	HUD.level.entity[HUD.hero].teleport(proportion)
	#sync_animation()
"""
func sync_animation() -> void:
	var view: AnimatedSprite2D = moves.hero.view.profile # print("SYNCED animation: ", view.animation, " - and frame: ", view.frame)
	sync_anim.emit(view.animation, view.frame)
"""
