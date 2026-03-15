extends Node

const TIME: float = 0.25
const OFF: float = 0.5

var appeared: bool = false
@onready var m: Control = get_node("../content/margin/title/animation")
#	custom_minimum_size

func disappear(ui: Control) -> Tween:
	#if appeared:
	appeared = false
	var tween: Tween = create_tween()
	# tween.tween_property(ui, "modulate", Color.TRANSPARENT, 2.6).set_delay(2)
	tween.set_parallel(true)
	tween.tween_method(func(v): m.custom_minimum_size.y = v, 0, 20, 0.25)
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, 0.25)
	return tween
	# m.add_theme_constant_override(p, MARGIN)
#	return null

func appear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	if not appeared:
		tween.set_parallel(true)
		tween.tween_property(ui, "modulate", Color.WHITE, TIME)
		tween.tween_method(func(v): m.custom_minimum_size.y = v, 20, 0, OFF)
		appeared = true
	return tween
