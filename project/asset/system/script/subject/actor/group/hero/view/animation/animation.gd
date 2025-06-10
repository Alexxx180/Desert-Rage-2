extends AdvancedCharacterAnimation

var hero: CharacterBody2D
var pose: String = "idle"
var maze: String = "go"
var go: Array[String] = ["walk", "run"]

func _ready() -> void: _direct()
func sync(tree: AnimationTree) -> void:
	var d = tree.direction
	_direction = d
	set_speed(tree.scale)
	_move_hero("idle") # tree.pose
	#action_move(tree.maze)
	_direct()
	#super.sync(tree)

func set_position(proportion: float) -> void: hero.move(proportion)

func start_dash() -> void: hero.logic.jump_sequence(true)
func stop_dash() -> void:
	var direction = _direction
	hero.logic.jump_sequence(false)
	action_move()
	_direction = direction

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
