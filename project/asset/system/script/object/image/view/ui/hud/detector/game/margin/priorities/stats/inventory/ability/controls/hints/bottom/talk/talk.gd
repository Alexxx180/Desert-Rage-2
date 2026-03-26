extends MarginContainer

@onready var borders: PanelContainer = $borders

const DURATION: float = 1.0

var animations: Dictionary = {
	"L": "look", "R": "rage", "G": "grin", "S": "smile",
	"A": "amaze", "T": "tired", "B": "but", "N": "sign",
	"C": "confirm", "P": "respect", "E": "anger",
	"Y": "play", "I": "rain"
}

func show_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders.image, "modulate", Color.TRANSPARENT, DURATION)

func hide_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders.image, "modulate", Color.TRANSPARENT, DURATION)
	borders.image.stop()

func set_animation(caption: String) -> void:
	if not borders.image.playing: show_animation()
	borders.image.play(caption)
