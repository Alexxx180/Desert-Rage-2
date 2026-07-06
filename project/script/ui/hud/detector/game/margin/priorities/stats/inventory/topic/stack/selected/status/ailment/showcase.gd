extends VBoxContainer

@onready var space: Control = $space
@onready var status: Control = $status

const PIN: Vector2i = Vector2i(0, 15)
const DURATION: int = 2

func toggle(pos: Vector2, clr: Color, feedback: Callable) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(space, "custom_minimum_size", pos, DURATION)
	tween.tween_property(space, "modulate", clr, DURATION)
	tween.tween_callback(feedback)

func shows() -> void:
	space.custom_minimum_size = PIN
	toggle(Vector2.ZERO, Color.WHITE, show)

func hides() -> void:
	toggle(PIN, Color.TRANSPARENT, hide)
