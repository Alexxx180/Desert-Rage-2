extends CanvasLayer

@onready var topics: VBoxContainer = $detector/margin/topics
@onready var detector: Panel = $detector

func set_back(menu: CanvasLayer) -> void:
	topics.tabs.set_back(self, menu)

func _ready() -> void:
	topics.tabs.caption.set_shortcut(self)
