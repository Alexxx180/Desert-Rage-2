extends VBoxContainer

@onready var heroes: Array[VBoxContainer] = [$heroes/ray, $heroes/rock]

func set_stats(stats: Dictionary) -> void:
	heroes[0].set_stats(stats.ray)
