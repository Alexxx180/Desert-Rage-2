extends HBoxContainer

@onready var drop: Button = $drop
@onready var add: Button = $add
@onready var search: Button = $search

func get_options(play: Button) -> Array[Button]:
	return [drop, add, search, play]
