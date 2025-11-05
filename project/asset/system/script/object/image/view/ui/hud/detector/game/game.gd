extends Control

@onready var options: HFlowContainer = $menu/stats/inventory/ability/controls/topic
@onready var chat: VBoxContainer = $dialog/chat
@onready var controls: VBoxContainer = $menu/stats/inventory/ability/controls
@onready var status: HBoxContainer = controls.get_node("topic/items/status")
@onready var markers: HFlowContainer = controls.get_node("markers")
@onready var statuses: Dictionary = {
	"ray": markers.get_node("margin/score/stack/ray"),
	"rock": markers.get_node("margin/score/stack/rock")
}
@onready var preview: HBoxContainer = controls.get_node("hints/space/preview")
@onready var hints: VBoxContainer = preview.get_node("help/content/help/hints")
@onready var inventory: PanelContainer = $menu/stats/inventory/topic
@onready var ability: PanelContainer = $menu/stats/inventory/ability/topic
@onready var stats: PanelContainer = $menu/stats/topic
@onready var priorities: PanelContainer = $menu/priorities

@onready var hp: Dictionary = _get_points("health")
@onready var ap: Dictionary = _get_points("ability")

func get_enemy_cards() -> Array:
	return [status.get_node("enemy_1"), ability.get_node("scroll/margin/stack/menu/fast-access/enemy_1")]

func _get_points(caption: String) -> Dictionary:
	return {
		"ray": _get_point_bars("ray", caption),
		"rock": _get_point_bars("rock", caption),
	}

func _get_point_bars(hero: String, caption: String) -> Array[Button]:
	return [
		get_node("menu/stats/inventory/topic/scroll/margin/stack/flow/controls/summary/status/" + hero + "/" + caption),
		get_node("menu/priorities/scroll/margin/stack/summary/status/" + hero + "/" + caption)
	]

func set_hp_value(hero: String, value: int) -> void: for bar in hp[hero]: bar.set_value(value)
func set_ap_value(hero: String, value: int) -> void: for bar in ap[hero]: bar.set_value(value)
