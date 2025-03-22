extends AnimationTree

const SPEED: int = 4

var scale: float = SPEED
var pose: String = "idle"
var go: Array[String] = ["walk", "run"]

var _direction: Vector2 = Vector2(0, -1)
var direction: Vector2:
	get: return _direction

func _ready() -> void: _direct()

func sync(tree: AnimationTree) -> void:
	_direction = tree.direction
	set_speed(tree.scale)
	_move_hero(tree.pose)
	_direct()

func set_speed(mach: int) -> void:
	scale = SPEED * mach
	set("parameters/go/transition_request", go[min(mach - 1, 1)])

func _move_hero(stand: String) -> void:
	pose = stand
	set("parameters/passive/transition_request", pose)

func _direct() -> void:
	for animation in ["idle-1", "walk", "run"]:
		set("parameters/%s/blend_position" % animation, _direction)

func move(motion: Vector2) -> void:
	_direction = motion
	if (_direction == Vector2.ZERO):
		_move_hero("idle")
	else:
		_direct()
		_move_hero("move")
