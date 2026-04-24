extends RichTextLabel

@onready var margin: MarginContainer = $margin
@onready var showcase: Button = $showcase

@export var hint: HelpHint
var helping: bool = false

func update_hint(params: Array) -> void:
	margin.title.text = hint.key("T")
	margin.caption.text = hint.key("D") % params

func translate(controls: Node) -> void:
	update_hint(controls.masked_translate(hint.body))

func _ready() -> void:
	if hint: update_hint(Defaults.ARRAY)

func _change_state(color: Color) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", color, 0.5)
	tween.set_parallel(false)
	return tween

func toggle(state: bool) -> void:
	helping = state
	margin.caption.visible = state
	visible = state

func show_delayed() -> void:
	modulate = Color.TRANSPARENT
	toggle(true) ; _change_state(Color.WHITE)
	
func hide_delayed() -> void:
	_change_state(Color.TRANSPARENT).tween_callback(func(): toggle(false)) # await get_tree().create_timer(1).timeout
