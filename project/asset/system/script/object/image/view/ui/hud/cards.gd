extends CanvasLayer

@export var progress: HelpPreview
@onready var hud: Control = $hud

func _ready() -> void:
	hud.detector.game.margin.hints.preview = progress
