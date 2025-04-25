extends CanvasLayer

const LEVEL: String = "%s/%s/%d"

@onready var detector: Control = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func set_preview(group: Node2D, progress: HelpPreview) -> void:
	detector.game.hints.set_preview(group, progress)

func set_settings_transition(settings: CanvasLayer) -> void:
	detector.pause.options.menu.settings.pressed.connect(func():
		hide()
		settings.show()
	)

func _ready() -> void: relation.controls(self)
