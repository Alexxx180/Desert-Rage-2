extends HSplitContainer

@onready var stats: HSplitContainer = $stats
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation
@onready var bars: Dictionary = _get_bars()

func _get_points(hero: String, caption: String) -> Array[Button]:
	return [
		stats.inventory.topic.selected.status.get(hero).get(caption),
		topic.stack.status.get(hero).get(caption)
	]

func _get_bars() -> Dictionary:
	var bars: Dictionary = {}
	for points in ["health", "ability"]:
		bars[points] = {}
		for hero in ["ray", "rock"]: bars[points][hero] = _get_points(hero, points)
	return bars

func set_points(points: String, hero: String, value: int) -> void:
	for bar in bars[points][hero]: bar.set_value(value)
