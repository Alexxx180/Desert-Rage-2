extends RefCounted

class_name InputAxis

var axis: Callable

func _init(straight: String, opposite: String) -> void:
	axis = (func(): Input.get_axis(straight, opposite))
