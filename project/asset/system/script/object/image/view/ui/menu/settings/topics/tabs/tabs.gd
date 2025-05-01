extends HFlowContainer

@onready var caption: Control = $caption
@onready var exit: Control = $exit

func set_back(settings: CanvasLayer, menu: CanvasLayer) -> void:
	exit.pressed.connect(func():
		settings.hide()
		menu.detector.pause.show()
	)
