extends Control

@onready var collapsed: Button = $collapsed
@onready var showcase: Button = $showcase

const TIME: float = 0.2

func _ready() -> void:
	for button in [collapsed, showcase]:
		button.pressed.connect(flip_the_card)

func flip_the_card() -> void:
	# collapsed.visible = showcase.visible
	# showcase.visible = !showcase.visible
	if showcase.scale == Vector2.ONE:
		_change_states(collapsed, showcase)
	else:
		_change_states(showcase, collapsed)

func _change_states(prev: CanvasItem, next: CanvasItem) -> void:
	_change_state(prev, 1.0, true)
	_change_state(next, 0.0, false)

func _change_state(subject: CanvasItem, scales: float, visibility: bool) -> void:
	create_tween().tween_property(subject, "scale", Vector2(scales, 1), TIME)
	# create_tween().tween_property(subject, "visible", visibility, TIME)
	
