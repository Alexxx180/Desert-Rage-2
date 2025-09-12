extends Control

@onready var options: HFlowContainer = $menu/stats/inventory/ability/controls/topic
@onready var chat: VBoxContainer = $dialog/chat
@onready var controls: VBoxContainer = $menu/stats/inventory/ability/controls
@onready var status: HBoxContainer = controls.get_node("topic/items/status")
@onready var markers: HFlowContainer = controls.get_node("markers")
@onready var preview: HBoxContainer = controls.get_node("hints/space/preview")
@onready var hints: VBoxContainer = preview.get_node("help/content/help/hints")
@onready var inventory: PanelContainer = $menu/stats/inventory/topic
@onready var ability: PanelContainer = $menu/stats/inventory/ability/topic
@onready var stats: PanelContainer = $menu/stats/topic

@onready var hp: Array[HBoxContainer] = _get_point_bars("health")
@onready var ap: Array[HBoxContainer] = _get_point_bars("influence")

func get_enemy_cards() -> Array:
	return [status.get_node("enemy_1"), ability.get_node("scroll/margin/stack/menu/fast-access/enemy_1")]

func _get_point_bars(caption: String) -> Array[HBoxContainer]:
	return [
		get_node("menu/stats/inventory/topic/scroll/margin/stack/flow/controls/status/ray/" + caption),
		get_node("menu/priorities/scroll/margin/stack/status/ray/" + caption)
	]

func set_hp_value(value: int) -> void: for bar in hp: bar.set_value(value)
func set_ap_value(value: int) -> void: for bar in ap: bar.set_value(value)
