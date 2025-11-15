extends BoxContainer

@export var keys: Array[String] = ["", ""]

func set_stats(stats: Dictionary) -> void:  # ["power", "health"]
	for key in keys: get_node(key).text = stats[key]
