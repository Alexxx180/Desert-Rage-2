extends Node

const TIME: float = 0.25
const MARGIN: int = 20

var appeared: bool = false
@onready var m: MarginContainer = get_node("../content/margin")

func set_margin(v: int) -> void:
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)

func disappear(ui: Control) -> Tween:
	appeared = false
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_margin, 0, MARGIN, TIME)
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, TIME)
	return tween

func appear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	if not appeared:
		tween.set_parallel(true)
		tween.tween_property(ui, "modulate", Color.WHITE, TIME)
		tween.tween_method(set_margin, MARGIN, 0, TIME)
		appeared = true
	return tween
