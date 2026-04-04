extends Node

const DURATION: float = 0.5
const DELAY: float = 0.15

func set_color(target: Color) -> void:
	for i in get_children():
		i.color = target

func _transit(target: Color = Color.BLACK) -> Tween:
	var tween: Tween = create_tween()
	for i in 3:
		var delay: float = DELAY * i
		tween.tween_property(get_node("ledge_%d" % (i + 1)), "modulate", target, DURATION - delay).set_delay(delay)
	return tween
