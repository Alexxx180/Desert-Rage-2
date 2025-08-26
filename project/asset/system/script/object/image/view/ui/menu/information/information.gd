extends CanvasLayer

@onready var back: Button = $detector/submit/back

func set_transition(game: CanvasLayer) -> void:
	back.pressed.connect(func(): hide(); game.detector.pause.show())
