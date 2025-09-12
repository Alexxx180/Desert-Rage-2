extends VBoxContainer

@onready var stats: Array[VBoxContainer] = [$power, $influence, $vitality, $reaction]

func set_stats(values: Array) -> void:
	for i in range(0, len(stats)):
		stats[i].set_base(values[i])
