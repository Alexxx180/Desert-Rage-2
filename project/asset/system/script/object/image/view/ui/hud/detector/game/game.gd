extends Control

@onready var priorities: HSplitContainer = $priorities
@onready var controls: VBoxContainer = priorities.stats.inventory.ability.controls

@onready var hp: Dictionary = _get_points("health")
@onready var ap: Dictionary = _get_points("ability")

func get_enemy_cards() -> Array:
	return [controls.topic.status.enemy_1,
		priorities.stats.inventory.ability.topic.fast_access.status.enemy_1]

func _get_points(caption: String) -> Dictionary:
	return {
		"ray": _get_point_bars("ray", caption),
		"rock": _get_point_bars("rock", caption),
	}

func _get_point_bars(hero: String, caption: String) -> Array[Button]:
	return [
		priorities.stats.inventory.topic.selected.status.get(hero).get(caption),
		priorities.topic.stack.status.get(hero).get(caption)
	]

func set_hp_value(hero: String, value: int) -> void: for bar in hp[hero]: bar.set_value(value)
func set_ap_value(hero: String, value: int) -> void: for bar in ap[hero]: bar.set_value(value)
