extends Label

@onready var title: Label = $title

func say(who: String, what: String) -> void:
	title.text = who
	text = what
