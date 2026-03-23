extends PanelContainer

@export var borders: StyleBoxFlat
@onready var image: TextureRect = $image

const DURATION: float = 1.0

var colors: Dictionary = {
	"peace": { "color": "#0f0f0f", "back": "#dcdcdc" },
	"fight": { "color": "#dcdcdc", "back": "#0f0f0f" }
}

func _ready() -> void:
	set("theme_override_styles/panel", borders)
	var tween = create_tween()
	tween.set_parallel(true)
	#tween.tween_method(func()L:
	
	#)
	tween.tween_property(borders, "bg_color", Color(colors.fight.back), DURATION).set_delay(3)
	tween.tween_property(borders, "border_color", Color(colors.fight.color), DURATION).set_delay(3)
