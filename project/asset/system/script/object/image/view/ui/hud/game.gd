extends CanvasLayer

const LEVEL: String = "%s/%s/%d"

@onready var detector: Control = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func set_preview(group: Node2D, progress: HelpPreview) -> void:
	detector.game.hints.set_preview(group, progress)

func set_settings_transition(settings: CanvasLayer, ost: AudioStreamPlayer) -> void:
	detector.game.visibility_changed.connect(func():
		ost.stream_paused = !detector.game.visible
	)
	
	relation.pause.settings.switch.transit_settings = func():
		detector.pause.hide(); settings.show()

func _ready() -> void: relation.controls(self)
