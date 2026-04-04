class_name BlackoutTransition extends RefCounted

const DURATION: float = 0.5
const DELAY: float = 0.15

var scene: String

func set_ledge_color(ledges: Control, target: Color) -> void:
	for l in ledges.get_children(): l.color = target

func as_way(way: ColorRect, target: Color, end: bool = false) -> void:
	var tween: Tween = way.create_tween()
	tween.tween_property(way, "modulate", target, DELAY)
	if end: tween.tween_callback(func(): end_transition(way))

func as_ledges(ledges: Control, target: Color = Color.BLACK, end: bool = false) -> void:
	var tween: Tween = ledges.create_tween()
	tween.set_parallel(true)
	for i in 3:
		var delay: float = DELAY * i
		var ledge: ColorRect = ledges.get_node("ledge_%d" % (i + 1))
		tween.tween_property(ledge, "modulate", target, DURATION - delay).set_delay(delay)
	if end: tween.tween_callback(func(): end_transition(ledges))

func end_transition(logic: Node) -> void:
	print_debug(logic.get_tree().call_deferred("change_scene_to_file", scene))
