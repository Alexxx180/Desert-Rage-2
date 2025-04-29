extends CanvasLayer

@onready var detector: Control = $detector

func _ready() -> void:
	# var dialog: FileDialog = FileDialog.new()
	# print("OPTION: ", dialog.get_option_values(0))
	$processor.set_soundtrack(detector.soundtrack)

func set_settings_transition(settings: CanvasLayer) -> void:
	detector.soundtrack.options.back.pressed.connect(
		func(): hide(); settings.show()
	)
