extends CanvasLayer

@onready var topics: VBoxContainer = $detector/margin/scroll/margin/topics

func set_back(menu: CanvasLayer) -> void:
	topics.tabs.set_back(self, menu)
