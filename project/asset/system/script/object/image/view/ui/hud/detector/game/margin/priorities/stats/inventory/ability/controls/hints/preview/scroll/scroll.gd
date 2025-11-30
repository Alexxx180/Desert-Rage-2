extends ScrollContainer

@onready var chat: VBoxContainer = $list/temp/chat
@onready var log: VBoxContainer = $list/temp/log

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)
