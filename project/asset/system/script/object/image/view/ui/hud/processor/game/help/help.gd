extends InputObserver

var list: VBoxContainer

var _level: int = 0
var level: int:
	get: return _level
	set(value):
		_level = value

func add_log() -> void:
	pass

func _l(a: String, b: String, entry: String):
	if a.begins_with(entry): return true
	return b.begins_with(entry)

func add_chat(queue: Array) -> void:
	var lvl: int = 0
	var entry: String = "L" + str(lvl)
	var level: int = queue.bsearch_custom(entry, func(a, b): _l(a, b, entry))
