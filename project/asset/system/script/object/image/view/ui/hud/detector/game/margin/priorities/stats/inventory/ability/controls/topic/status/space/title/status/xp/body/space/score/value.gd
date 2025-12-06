extends Control

@onready var level_up: TextureRect = $level_up
@onready var value: Label = $value

const DELAY: int = 2

var first_entry: bool = true
# var fill: StyleBoxFlat = StyleBoxFlat.new() # TODOT STATUS

func new_level_up(_level: Node, _stats: Dictionary) -> void:
	if first_entry:
		first_entry = false
		return
	# if level.summary.xp == 0: return
	level_up.modulate = Color.WHITE
	create_tween().tween_property(level_up, "modulate", Color.TRANSPARENT, DELAY).set_delay(DELAY)

"""
func _ready() -> void:
	level_up.mouse_entered.connect(value.show) # next
	level_up.mouse_exited.connect(value.hide) # next
"""
