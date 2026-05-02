extends HSplitContainer

@onready var stats: HSplitContainer = $stats
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

var _bars: Dictionary = Def.DICT
var bars: Dictionary:
	get:
		if _bars == Def.DICT:
			_bars = _get_bars()
		return _bars

func _ready() -> void: drag_started.connect(topic.update_stack)

func _get_points(hero: String, caption: String) -> Array[Button]:
	return [
		stats.inventory.topic.stack.status.get(hero).get(caption),
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
