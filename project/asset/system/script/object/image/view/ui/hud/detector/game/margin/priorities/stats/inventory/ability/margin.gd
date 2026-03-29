extends MarginContainer

@onready var ui: Window = get_window()

func _ready():
	get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()

func _on_viewport_resize():
	var margin: Vector2 = Vector2(ui.size.x * 0.01, ui.size.y * 0.01)
	set("theme_override_constants/margin_left", margin.x)
	set("theme_override_constants/margin_right", margin.x)
	set("theme_override_constants/margin_top", margin.y)
	set("theme_override_constants/margin_bottom", margin.y)
	# Starts the timer or resets its time_left if already running.

func _on_view_port_resize_timer_timeout():
	print("viewport size has stabilized - do performance-heavy stuff")
