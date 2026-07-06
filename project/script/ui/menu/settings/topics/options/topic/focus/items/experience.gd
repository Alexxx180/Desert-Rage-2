extends FocusedItems

func _ready() -> void:
	var game: MarginContainer = get_parent() 
	var xp: VBoxContainer = game.get_node("experience")
	_topics.push_back(xp.sound.options.get_parent())
	_topics.push_back(xp.experience.options.get_parent())
	_topics.push_back(xp.interface.options.get_parent())
	_topics.push_back(xp.stats)
	_items.push_back(xp.sound.options.get_items(self))
	_items.push_back(xp.experience.options.get_items())
	_items.push_back(xp.interface.options.get_items())
	_items.push_back(xp.stats.get_items())
	setup(game)
