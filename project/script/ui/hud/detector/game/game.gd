extends Control

@onready var right: HSplitContainer = $right
@onready var left: HSplitContainer = right.get_node(^"left")
@onready var top: VSplitContainer = left.get_node(^"top")
@onready var bottom: VSplitContainer = top.get_node(^"bottom")

@onready var priorities: PanelContainer = right.get_node(^"priorities")
@onready var stats: PanelContainer = left.get_node(^"stats")
@onready var inventory: PanelContainer = top.get_node(^"inventory")
@onready var ability: PanelContainer = bottom.get_node(^"ability")

@onready var margin: MarginContainer = bottom.get_node(^"margin")
@onready var controls: VBoxContainer = margin.get_node(^"controls")

@onready var help: VBoxContainer = controls.get_node(^"middle/help")

"""
func _ready():
	get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()
"""

func _on_viewport_resize():
	var ui: Window = get_window()
	var margins: Vector2 = Vector2(ui.size.x * 0.01, ui.size.y * 0.01)
	set("theme_override_constants/margin_left", margins.x)
	set("theme_override_constants/margin_right", margins.x)
	set("theme_override_constants/margin_top", margins.y)
	set("theme_override_constants/margin_bottom", margins.y)
	# Starts the timer or resets its time_left if already running.

func _on_view_port_resize_timer_timeout():
	print("viewport size has stabilized - do performance-heavy stuff")
