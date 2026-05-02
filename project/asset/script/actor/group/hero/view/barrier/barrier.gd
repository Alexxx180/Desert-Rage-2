extends Button

const ATB: Color = Color8(255, 255, 150, 255)
const TIME: float = 0.25

@onready var barrier: ColorRect = $barrier

func set_fill(horizont: Control.SizeFlags, vertical: Control.SizeFlags) -> void:
	barrier.size_flags_horizontal = horizont
	barrier.size_flags_vertical = vertical

func set_direction(dir: Vector2) -> void:
	match dir:
		Vector2.ZERO: return
		Vector2(1, 0), Vector2(1, -1): set_fill(Control.SIZE_SHRINK_END, Control.SIZE_FILL)
		Vector2(0, 1), Vector2(1, 1): set_fill(Control.SIZE_FILL, Control.SIZE_SHRINK_END)
		Vector2(-1, 0), Vector2(-1, 1): set_fill(Control.SIZE_SHRINK_BEGIN, Control.SIZE_FILL)
		Vector2(0, -1), Vector2(1, 1): set_fill(Control.SIZE_FILL, Control.SIZE_SHRINK_BEGIN)

func set_atb(portion: float) -> void:
	print("ATB PORTION: ", portion)

func set_block() -> void:
	create_tween().tween_property(barrier, "color", ATB, TIME)

func appear(ui: Control) -> void: ui.modulate = Color.WHITE
