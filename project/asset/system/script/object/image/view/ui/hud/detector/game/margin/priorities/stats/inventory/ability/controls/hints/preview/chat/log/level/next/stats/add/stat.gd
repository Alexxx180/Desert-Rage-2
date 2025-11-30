extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

func _reveal(feedback: Callable) -> void:
	for i in range(0, len(group)):
		feedback.call(i, group[i].value)

func set_stats(stats: Dictionary) -> void:
	_reveal(func(i, v):
		var value: int = stats.delta[keys[i]]
		v.text = str(value))

func reveal_stats() -> void:
	_reveal(func(i, v): v.hide())
