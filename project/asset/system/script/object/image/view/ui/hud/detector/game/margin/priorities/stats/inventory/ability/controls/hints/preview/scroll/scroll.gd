extends ScrollContainer

@onready var list: VBoxContainer = $list

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)
