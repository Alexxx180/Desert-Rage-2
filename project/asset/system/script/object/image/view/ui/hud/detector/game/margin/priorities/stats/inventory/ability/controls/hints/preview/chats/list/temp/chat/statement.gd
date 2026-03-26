extends Label

@onready var title: Label = $title

func say(who: String, key: String) -> void:
	title.text = who
	text = key
