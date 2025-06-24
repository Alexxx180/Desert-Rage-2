extends AdvancedCharacterAnimation

signal close_damage(points: int)

const DOUBLE_COMBO: int = 2

@onready var stance: Timer = $stance

var hero: CharacterBody2D
var go: Array[String] = ["walk", "run"]

func _ready() -> void: _direct()
func sync(tree: AnimationTree) -> void:
	hero = tree.hero
	var d = tree.direction
	_direction = d
	request("go", tree.ask("go")) # set_speed(tree.scale)
	_move_hero("idle") # tree.pose
	action_move(tree.ask("move")) # maze
	_direct()
	#super.sync(tree)

func _direct() -> void:
	super._direct()
	if not Input.is_action_pressed("action"): blend("pull_forward")

func start_dash() -> void: hero.logic.jump_sequence(true)
func stop_dash() -> void:
	var temp: Vector2i = _direction
	hero.logic.jump_sequence(false)
	action_move()
	_direction = temp

func set_speed(mach: int) -> void: request("go", go[min(mach - 1, 1)]) # scale = SPEED * mach
func set_position(proportion: float) -> void: hero.move(proportion)
func action_move(stand: String = "go") -> void: request("move", stand)
func _move_hero(stand: String) -> void: request("passive", stand)
func fight_body(stand: String) -> void:
	request("active", stand)
	if stand == "hands":
		var combo: int = (int(ask("punch_combo")) + 1) % DOUBLE_COMBO
		request("punch_combo", combo)
	
func start_fight(stand: String) -> void:
	request("character", stand)
	stance.start()

func end_fight() -> void: request("character", "passive")

func set_damage(points: int = 5) -> void: close_damage.emit(points)

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: _move_hero("move")
	else: _move_hero("idle")
	return turned
