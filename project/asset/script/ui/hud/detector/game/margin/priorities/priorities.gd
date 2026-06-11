extends HSplitContainer

@onready var stats: HSplitContainer = $stats
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation
@onready var points: Array[Button] = _get_points()

func _ready() -> void: drag_started.connect(topic.update_stack)

func _get_points() -> Array[Button]:
	var items: MarginContainer = stats.inventory.topic.stack.status
	var file: MarginContainer = topic.stack.status
	return [
		items.get(&"ray").get(&"health"), file.get(&"ray").get(&"health"),
		items.get(&"ray").get(&"ability"), file.get(&"ray").get(&"ability"),
		items.get(&"rock").get(&"health"), file.get(&"rock").get(&"health"),
		items.get(&"rock").get(&"ability"), file.get(&"rock").get(&"ability"),
	]
