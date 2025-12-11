extends VBoxContainer

@onready var up: ColorRect = $up
@onready var options: HBoxContainer = $options
@onready var down: ColorRect = $down

func set_direction(dir: Vector2) -> void:
	if not options.shows(dir.y, up, down):
		options.set_direction(dir)

func set_atb(portion: float) -> void:
	options.acting(portion, up, down)
	options.set_atb(portion)
	print("ATB PORTION: ", portion)

func set_block() -> void:
	options.visualize_block(up, down)
	options.set_block()

func appear(ui: Control) -> void:
	ui.modulate = Color.WHITE
