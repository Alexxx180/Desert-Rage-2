extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

var now: Array[int] = [0, 0]

func set_stats(stats: Dictionary) -> void:  # ["power", "health"]
	for i in range(0, len(group)):
		now[i] = stats.now[keys[i]]
		group[i].text = str(now[i] - stats.delta[i])

func reveal_stats() -> void:
	for i in range(0, len(group)):
		group[i].text = str(now[i])
