extends Control

@onready var level_up: TextureRect = $level_up
@onready var count: Label = $count

const DELAY: int = 2

var fill: StyleBoxFlat = StyleBoxFlat.new() # TODOT STATUS

func new_level_up(_level: Node, _stats: Dictionary) -> void:
	level_up.modulate.a8 = 255
	create_tween().tween_property(level_up, "modulate", Color.TRANSPARENT, DELAY).set_delay(DELAY)

func _ready() -> void:
	level_up.mouse_entered.connect(count.show) # next
	level_up.mouse_exited.connect(count.hide) # next
