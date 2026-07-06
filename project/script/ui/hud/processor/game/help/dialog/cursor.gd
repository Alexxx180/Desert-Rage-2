class_name DialogCursor extends RefCounted

var level: int = 0
var cursor: int = 0
var backlog: int = 0

var block: Node
var queue: Array[int] = []
var talking: bool:
	get: return not queue.is_empty()
var chat: int:
	get: return queue.pop_front()

func set_level(value: int, position: int) -> void: # LEVEL USUALLY set after level finish or on load
	level = value
	cursor = position # locale.get_chat(value)
	backlog = cursor - 1

func scroll(locale: Node) -> void:
	if backlog == -1: return

	for i in range(5):
		if not locale.with(backlog, "L"):
			backlog = -1 ; break
		var key: String = locale.text(backlog)
		block.insert_chat(block.chat(key), block.chat(key))
		backlog -= 1

func find_part(locale: Node, key: String) -> int:
	var i: int = cursor
	while not locale.with(i, key): i += 1
	return i

func add_queue(locale: Node, key: String) -> void:
	var i: int = find_part(locale, key)
	while locale.with(i, key):
		queue.append(i)
		i += 1
