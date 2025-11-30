extends VBoxContainer

@onready var title: Label = $description/caption/title
@onready var state: Label = $description/statement
"""
func _ready() -> void: Locale.update.connect()
func _set_language() -> void:
	title.text = Locale.LANG[key[0]]
	state.text = Locale.LANG[key[1]]
"""
func say(who: String, what: String) -> void:
	title.text = who
	state.text = what
