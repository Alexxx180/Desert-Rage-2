extends Control

@onready var options: HFlowContainer = $menu/stats/inventory/ability/controls/topic
@onready var chat: VBoxContainer = $dialog/chat
@onready var hints: VBoxContainer = $menu/stats/inventory/ability/controls/hints/scroll/stack/hints
@onready var inventory: PanelContainer = $menu/stats/inventory/topic

@onready var hp: Array[HBoxContainer] = _get_point_bars("health")
@onready var ap: Array[HBoxContainer] = _get_point_bars("influence")
func _get_point_bars(caption: String) -> Array[HBoxContainer]:
	return [
		get_node("menu/stats/inventory/topic/scroll/margin/flow/status/" + caption),
		get_node("menu/priorities/scroll/margin/stack/status/" + caption)
	]

func set_hp_value(value: int) -> void: for bar in hp: bar.set_value(value)
func set_ap_value(value: int) -> void: for bar in ap: bar.set_value(value)
