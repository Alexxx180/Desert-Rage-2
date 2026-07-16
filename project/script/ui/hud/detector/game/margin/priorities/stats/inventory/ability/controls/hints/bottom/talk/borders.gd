extends Panel

@onready var borders: StyleBoxFlat = get("theme_override_styles/panel")
@onready var image: TextureRect = $image # @onready var borders: PanelContainer = $borders

const DURATION: float = 1.0 # const DURATION: float = 1.0

const animations: PackedStringArray = ["look", "rage", "grin", "smile", "amaze",
	"tired", "but", "sign", "confirm", "respect", "anger", "play", "rain"]
const keys: String = "LRGSATBNCPEYI"

func show_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.WHITE, DURATION)

func hide_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.TRANSPARENT, DURATION)
	borders.image.stop()

func set_animation(caption: String) -> void:
	if not borders.image.playing: show_animation()
	borders.image.play(caption)

func set_environment(state: bool) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	var bg: StringName; var border: StringName
	if state: bg = &"#0f0f0f" ; border = &"#dcdcdc"
	else: bg = &"#dcdcdc" ; border = &"#0f0f0f"
	tween.tween_property(borders, ^"bg_color", Color(bg), DURATION).set_delay(DURATION)
	tween.tween_property(borders, ^"border_color", Color(border), DURATION).set_delay(DURATION)
