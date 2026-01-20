extends Control

@onready var collapsed: Button = $collapsed
@onready var showcase: Button = $showcase

const TIME: float = 0.2

func get_locale() -> RichTextLabel:
	return $showcase/margin/content/caption

func _ready() -> void:
	for button in [collapsed, showcase]:
		button.pressed.connect(flip_the_card)

"""
func _r() -> void:
	var language = "automatic"
	# Load here language from the user settings file
	if language == "automatic":
	   var preferred_language = OS.get_locale_language()
	   TranslationServer.set_locale(preferred_language)
	else:
	   TranslationServer.set_locale(language)
"""

func flip_the_card() -> void: # collapsed.visible = showcase.visible # showcase.visible = !showcase.visible
	if collapsed.scale == Vector2.ONE:
		_change_states(showcase, collapsed)
	else:
		_change_states(collapsed, showcase)

func _change_states(prev: CanvasItem, next: CanvasItem) -> void:
	_change_state(prev, 1.0, true)
	_change_state(next, 0.0, false)

func _change_state(subject: CanvasItem, scales: float, visibility: bool) -> void:
	create_tween().tween_property(subject, "scale", Vector2(scales, 1), TIME)
	# create_tween().tween_property(subject, "visible", visibility, TIME)
	
