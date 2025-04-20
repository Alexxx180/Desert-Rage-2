extends HBoxContainer

@onready var drop: Button = $drop
@onready var add: Button = $add
@onready var search: Button = $search

var options: Array[Button]:
	get: return [drop, add, search]
