extends Control

@onready var options: HFlowContainer = $menu/stats/inventory/ability/controls/topic
@onready var chat: VBoxContainer = $dialog/chat
@onready var hints: VBoxContainer = $menu/stats/inventory/ability/controls/hints/scroll/stack/hints

@onready var hp: Array[HBoxContainer] = [
	$menu/stats/inventory/topic/scroll/margin/flow/status/health,
	$menu/priorities/scroll/margin/stack/status/health
]

@onready var ap: Array[HBoxContainer] = [
	$menu/stats/inventory/topic/scroll/margin/flow/status/influence,
	$menu/priorities/scroll/margin/stack/status/influence
]

func set_hp_value(value: int) -> void:
	for bar in hp: bar.set_value(value)

func set_ap_value(value: int) -> void:
	for bar in ap: bar.set_value(value)
