extends Timer

@onready var ui: Control = get_parent()
@onready var modulator: Node = $modulator

func _ready():
	if ui.has_method("disappear"):
		timeout.connect(ui.disappear)
	else:
		timeout.connect(disappear)

func disappear() -> Tween:
	return modulator.disappear(ui)

func appear() -> void:
	modulator.appear(ui)
	start()
