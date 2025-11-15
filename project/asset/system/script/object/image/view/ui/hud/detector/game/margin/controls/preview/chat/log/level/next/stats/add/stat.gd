extends VBoxContainer

@export var add: Array[String] = ["", ""]

func set_stats(stats: Dictionary) -> void:
	for stat in add: get(stat).value.text = stats[stat]
