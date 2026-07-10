extends PanelContainer

@onready var borders: StyleBoxFlat = get("theme_override_styles/panel")
@onready var image: TextureRect = $image # @onready var borders: PanelContainer = $borders

const DURATION: float = 1.0

var animations: Dictionary = {
	"L": "look", "R": "rage", "G": "grin", "S": "smile",
	"A": "amaze", "T": "tired", "B": "but", "N": "sign",
	"C": "confirm", "P": "respect", "E": "anger",
	"Y": "play", "I": "rain"
}
# const DURATION: float = 1.0
var colors: Dictionary = {
	"peace": { "color": "#0f0f0f", "back": "#dcdcdc" },
	"fight": { "color": "#dcdcdc", "back": "#0f0f0f" }
}

func show_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, "modulate", Color.WHITE, DURATION)

func hide_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, "modulate", Color.TRANSPARENT, DURATION)
	borders.image.stop()

func set_animation(caption: String) -> void:
	if not borders.image.playing: show_animation()
	borders.image.play(caption)

func set_environment(state: String = "fight") -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(borders, "bg_color", Color(colors.fight.back), DURATION).set_delay(DURATION)
	tween.tween_property(borders, "border_color", Color(colors.fight.color), DURATION).set_delay(DURATION)
