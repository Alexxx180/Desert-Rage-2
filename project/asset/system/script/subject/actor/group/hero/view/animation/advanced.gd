extends AnimationTree

class_name AdvancedCharacterAnimation

const SPEED: int = 4

var scale: float = SPEED

var _direction: Vector2 = Vector2(0, -1)
var direction: Vector2:
	get: return _direction

func ask(caption: String) -> Variant:
	return get("parameters/%s/current_state" % caption)

func request(caption: String, value: Variant) -> void:
	set("parameters/%s/transition_request" % caption, value)

func blend(caption: String) -> void:
	set("parameters/%s/blend_position" % caption, _direction)

func sync(tree: AnimationTree) -> void:
	_direction = tree.direction
	_direct()

func direct_animations() -> Array[String]:
	return ["idle-1", "walk", "run", "jump", "kick_1", "punch_1", "punch_2"]

func _direct() -> void:
	for animation in direct_animations():
		blend(animation)

func turn_direction() -> void: _direct()

func move(motion: Vector2) -> bool:
	_direction = motion
	var turned: bool = _direction != Vector2.ZERO
	if turned: _direct()
	return turned
