extends FocusedItems

func _ready() -> void:
	var game: MarginContainer = get_parent() 
	var space: VBoxContainer = game.get_node("experience")
	_items.push_back(space.sound.options.get_items(self))
	_items.push_back(space.experience.options.get_items())
	setup(game)
