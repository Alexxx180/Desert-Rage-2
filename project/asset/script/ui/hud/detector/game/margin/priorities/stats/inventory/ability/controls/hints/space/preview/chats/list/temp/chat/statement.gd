extends Label

const DURATION: float = 0.5

var title: Label

func say(who: String, key: String) -> void:
	title = $title
	title.text = who
	text = key
	create_tween().tween_property(title, "modulate", Color.TRANSPARENT, DURATION).set_delay(1)
