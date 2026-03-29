extends TextureRect

@onready var value: Label = $value

const DELAY: int = 2

var record: int
var text: int:
	set(next):
		if not is_new_level:
			value.text = str(next)
		else:
			record = next
var is_new_level: bool = false
var first_entry: bool = true

func set_effect() -> void:
	create_tween().tween_method(func(w: Color):
		self_modulate = w
		if w == Color.TRANSPARENT:
			is_new_level = false
			value.text = str(record)
		, Color.WHITE, Color.TRANSPARENT, DELAY).set_delay(DELAY)

func new_level_up(_level: Node, _stats: Dictionary) -> void:
	if is_new_level: return # if level.summary.xp == 0: return
	if first_entry: first_entry = false ; return
	is_new_level = true
	record = int(value.text)
	value.text = tr("RECD")
	set_effect()

"""
func _ready() -> void:
	level_up.mouse_entered.connect(value.show) # next
	level_up.mouse_exited.connect(value.hide) # next
"""
