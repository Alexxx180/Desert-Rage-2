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

func _new(key: String):
	pass

func insert_chat(key: String) -> void:
	locale.hud.chat.insert(_new(key))
	locale.panel.chat.insert(_new(key))

func _add_chat(key: String) -> void:
	locale.hud.temp.chat.add_child(_new(key))
	locale.hud.chat.add_child(_new(key))
	locale.panel.chat.add_child(_new(key))

func add_chat(part: int) -> void: _add_chat("L%d_%d" % [_level, part])
