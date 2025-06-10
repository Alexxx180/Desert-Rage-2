extends AnimationTree

class_name AdvancedCharacterAnimation

const SPEED: int = 4

var scale: float = SPEED

var _direction: Vector2 = Vector2(0, -1)
var direction: Vector2:
	get: return _direction

func request(caption: String, value: Variant) -> void:
	set("parameters/" + caption + "/transition_request", value)

func sync(tree: AnimationTree) -> void:
	_direction = tree.direction
	_direct()

func _direct() -> void:
	for animation in ["idle-1", "walk", "run", "jump", "pull_forward"]:
		set("parameters/%s/blend_position" % animation, _direction)

func turn_direction() -> void: _direct()

func move(motion: Vector2) -> bool:
	_direction = motion
	var turned: bool = _direction != Vector2.ZERO
	if turned: _direct()
	return turned
