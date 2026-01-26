extends PanelContainer

@onready var margin: MarginContainer = $margin
@onready var showcase: Button = $showcase

@export var hint: HelpHint

func update_hint(params: Array) -> void:
	margin.title.text = hint.key("T")
	margin.caption.text = hint.key("D") % params

func translate(controls: Node) -> void:
	update_hint(controls.masked_translate(hint.body))

# func _ready() -> void: if hint: update_hint()

func _change_state(color: Color) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", color, 0.5)
	tween.set_parallel(false)
	return tween

func show_delayed() -> void:
	show(); _change_state(Color.WHITE)
	
func hide_delayed() -> void:
	_change_state(Color.TRANSPARENT).tween_callback(hide) # await get_tree().create_timer(1).timeout
