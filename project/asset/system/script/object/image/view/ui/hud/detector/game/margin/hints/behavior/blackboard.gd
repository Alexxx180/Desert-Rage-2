extends BehaviorBlackboard

func set_values(names: Array[Variant], values: Array[Variant]) -> void:
	var i: int = values.size()
	while i > 0:
		i -= 1
		set_value(names[i], values[i])

func toggle_value(value_name: String) -> void:
	set_value(value_name, !get_value(value_name))
