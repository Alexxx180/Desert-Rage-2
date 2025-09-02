extends ControlTimeHider

func _change_state(color: Color) -> void:
	super._change_state(color)
	_tween_property("visible", color == Color.WHITE)
