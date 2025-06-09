extends AdvancedCharacterAnimation

var hero: CharacterBody2D
var pose: String = "idle"
var go: Array[String] = ["walk", "run"]

func _ready() -> void: _direct()
func sync(tree: AnimationTree) -> void:
	super.sync(tree)
	set_speed(tree.scale)
	_move_hero(tree.pose)

func set_position(proportion: float) -> void: hero.move(proportion)

func start_dash() -> void: hero.logic.jump_sequence(true)
func stop_dash() -> void:
	hero.logic.jump_sequence(false)
	action_move("go")

func action_move(stand: String) -> void: request("move", stand)

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
