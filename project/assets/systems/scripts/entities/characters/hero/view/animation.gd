extends AnimationTree

const SPEED: int = 4

var scale: float = SPEED
var pose: String = "idle"

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
	set("parameters/speed/scale", scale)

func _move_hero(stand: String) -> void:
	pose = stand
	set("parameters/passive/transition_request", pose)

func _direct() -> void:
	for animation in ["idle-1", "run"]:
		set("parameters/%s/blend_position" % animation, _direction)

func _input(_event: InputEvent) -> void:
	_direction = Input.get_vector("left", "right", "backward", "forward")
	if (_direction == Vector2.ZERO):
		_move_hero("idle")
	else:
		_direct()
		_move_hero("run")
