extends AdvancedCharacterAnimation

var hero: CharacterBody2D
var pose: String = "idle"
var maze: String = "go"
var go: Array[String] = ["walk", "run"]

func _ready() -> void: _direct()
func sync(tree: AnimationTree) -> void:
	hero = tree.hero
	var d = tree.direction
	_direction = d
	set_speed(tree.scale)
	_move_hero("idle") # tree.pose
	action_move(tree.maze)
	_direct()
	#super.sync(tree)

func _direct() -> void:
	super._direct()
	if not Input.is_action_pressed("action"):
		set("parameters/pull_forward/blend_position", _direction)

func set_position(proportion: float) -> void: hero.move(proportion)

func start_dash() -> void: hero.logic.jump_sequence(true)
func stop_dash() -> void:
	var temp: Vector2i = _direction
	hero.logic.jump_sequence(false)
	action_move()
	_direction = temp

func action_move(stand: String = "go") -> void:
	maze = stand
	request("move", stand)

func set_speed(mach: int) -> void:
	scale = SPEED * mach
	request("go", go[min(mach - 1, 1)])

func _move_hero(stand: String) -> void:
	pose = stand
	request("passive", pose)

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	_move_hero("move" if turned else "idle")
	return turned
