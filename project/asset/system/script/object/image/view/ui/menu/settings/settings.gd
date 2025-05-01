extends CanvasLayer

@onready var topics: VBoxContainer = $detector/margin/topics
@onready var detector: Panel = $detector

func set_transitions(menu: CanvasLayer, sound: CanvasLayer) -> void:
	topics.tabs.set_back(self, menu)
	topics.options.set_soundtrack_transition(self, sound)

func _ready() -> void:
	topics.tabs.caption.set_shortcut(self)
	topics.options.set_transition(self)
