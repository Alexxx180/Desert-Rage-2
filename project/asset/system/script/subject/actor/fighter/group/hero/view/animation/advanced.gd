extends AnimationTree

class_name AdvancedCharacterAnimation

const SPEED: int = 4

var scale: float = SPEED
var direction: Vector2 = Vector2(0, -1)

func ask(caption: String) -> Variant:
	return get("parameters/%s/current_state" % caption)

func request(caption: String, value: Variant) -> void:
	set("parameters/%s/transition_request" % caption, value)

func blend(caption: String) -> void:
	set("parameters/%s/blend_position" % caption, direction)

func direct_animations() -> Array[String]:
	return ["idle-1", "walk", "run", "jump", "kick_0", "kick_1",
		"punch_0", "punch_1", "whip_dash", "hang_go", "hang_idle",
		"bash", "stomp", "fire", "whip", "hang_whip_dash"]

func direct() -> void: for animation in direct_animations(): blend(animation)

func move(motion: Vector2) -> bool:
	direction = motion
	var turned: bool = direction != Vector2.ZERO
	if turned: direct()
	return turned
