extends CanvasLayer

@onready var topics: HBoxContainer = $detector/margin/topics
@onready var detector: Panel = $detector
@onready var music: HSlider = detector.get_node("margin/topics/content/options/game/experience/sound/content/options/music")

func first_focus() -> void:
	music.submit.grab_focus()

func set_transitions(menu: CanvasLayer, sound: CanvasLayer) -> void:
	topics.tabs.set_back(self, menu)
	topics.options.set_soundtrack_transition(self, sound)

func _ready() -> void:
	topics.tabs.caption.set_shortcut(self)
	topics.options.set_transition(self)
