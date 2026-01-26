extends Control

@onready var collapsed: Button = $collapsed
@onready var showcase: PanelContainer = $showcase

@export var hint: HelpHint

const TIME: float = 0.2

func update_locale() -> void:
	collapsed.title.text = hint.key("T")

func update_hint() -> void:
	collapsed.image.texture = hint.texture
	update_locale()
	showcase.hint = hint
	showcase.update_hint(Defaults.ARRAY)

func translate(controls: Node) -> void:
	update_locale()
	showcase.translate(controls)

func get_locale() -> RichTextLabel:
	return $showcase/margin.caption

func _ready() -> void:
	if hint: update_hint()
	for button in [collapsed, showcase.showcase]:
		button.pressed.connect(flip_the_card)

func flip_the_card() -> void:
	if collapsed.scale == Vector2.ONE:
		_change_states(showcase, collapsed)
	else:
		_change_states(collapsed, showcase)

func _change_states(prev: CanvasItem, next: CanvasItem) -> void:
	_change_state(prev, 1.0, true)
	_change_state(next, 0.0, false)

func _change_state(subject: CanvasItem, scales: float, visibility: bool) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(subject, "scale", Vector2(scales, 1), TIME)
	if visibility:
		subject.show()
	else:
		tween.tween_property(subject, "visible", visibility, TIME)
	
