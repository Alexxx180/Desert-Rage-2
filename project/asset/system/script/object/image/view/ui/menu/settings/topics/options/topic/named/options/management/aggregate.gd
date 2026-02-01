extends HBoxContainer

@onready var enter: Button = $enter
@onready var collapse: Button = $collapse

func connect_collapsing(options: Array) -> void:
	collapse.pressed.connect(toggle(options))

func toggle(options: Array) -> Callable: return func():
	var state: bool = !options.front().visible
	for b in options:
		b.visible = state
		print("B NAME: ", b.name, " - STATE: ", b.visible)
