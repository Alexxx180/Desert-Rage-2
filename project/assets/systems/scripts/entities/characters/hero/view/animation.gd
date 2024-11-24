extends AnimationTree

const SPEED: int = 4

func set_speed(mach: int) -> void:
	set("parameters/speed/scale", SPEED * mach)

func _move_hero(stand: String) -> void:
	set("parameters/passive/transition_request", stand)

func _direct() -> void:
	for animation in ["idle-1", "run"]:
		set("parameters/%s/blend_position" % animation, _direction)

var _direction: Vector2 = Vector2.ZERO

func _input(_event: InputEvent) -> void:
	_direction = Input.get_vector("left", "right", "backward", "forward")
	if (_direction == Vector2.ZERO):
		_move_hero("idle")
	else:
		_direct()
		_move_hero("run")
