extends PanelContainer

@onready var hero: VBoxContainer = $hero

func say(who: String, what: String) -> void:
	hero.say(who, what)
