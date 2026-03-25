extends Node

var queue: Array = []
var locale: Node
var _level: int = 0
var cursor: int = 0
var backlog: int = 0

func set_level(value: int) -> void: # LEVEL USUALLY set after level finish or on load
	_level = value
	cursor = locale.get_chat(value)
	backlog = cursor - 1

func scroll() -> void:
	if backlog == -1: return
	
	for i in range(5):
		var phrase: String = locale.locale[backlog]
		if not phrase.begins_with("L"):
			backlog = -1 ; break
		_add_chat(phrase)
		backlog -= 1

func insert_chat() -> void:
	

func _add_chat(key: String) -> void:
	ui

func add_chat(part: int) -> void: # func get_chat(level: int, part: int) -> void:
	var entry: String = "L%d_%d" % [_level, part]
	# locale.get_chat(part) 
