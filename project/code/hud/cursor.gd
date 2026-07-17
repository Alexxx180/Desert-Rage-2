class_name DialogCursor extends RefCounted

@onready var timer: Timer = $timer

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




var length: int = 0
var locale: Node
var nodes: Array = []

var who: Dictionary = { "R": "RAY", "K": "ROCK", "D": "DID", "Q": "???" }
var face: Dictionary = {
	"L": "look", "R": "rage", "G": "grin", "S": "smile", "C": "confirm",
	"T": "tired", "B": "but", "N": "sign", "A": "amaze", "P": "respect",
	"E": "anger", "Y": "play", "I": "rain", "W": "scare"
}

func set_level(value: int) -> void: cursor.set_level(value, locale.get_chat(value))
func scroll() -> void: cursor.scroll(locale)
func _ready() -> void: timer.timeout.connect(talking)

func add_chat(part: int) -> void:
	var key: String = "L%d_%d" % [cursor.level, part]
	cursor.add_queue(locale, key)
	timer.start()

func get_chatter(key: String) -> Dictionary:
	var alias: String = key[-2]
	assert(face.has(key[-1]), "Unknown emotion: %s" % key)
	assert(who.has(alias), "Unknown character: %s" % key)
	return { "face": face[key[-1]], "who": who[alias], "alias": alias }

func _new_chat_block() -> void:
	var key: String = locale.text(cursor.chat)
	var id: Dictionary = get_chatter(key)
	clear()
	length = len(tr(key)) ; nodes.clear()
	cursor.block.chats(id.who, nodes, key, 3)
	cursor.block.add_chat(nodes)
	cursor.block.set_emotion(id)

func plot_speech() -> void:
	for node in nodes: node.visible_characters += 1
	length -= 1

func clear() -> void: for node in nodes: node.visible_characters = -1

func stop_speech() -> void:
	clear()
	cursor.block.hide_emotion()
	timer.stop()

func talking() -> void:
	if length > 0:
		plot_speech()
	elif cursor.talking:
		_new_chat_block()
	else:
		stop_speech()





var _locale: Array = Def.ARRAY
var locale: Array:
	get:
		if _locale == Def.ARRAY: _locale = _get_locale()
		return _locale

func text(cursor: int) -> String: return locale[cursor]
func with(cursor: int, start: String) -> bool:
	return locale[cursor].begins_with(start)

func _get_locale() -> Array: # TODOT
	var result: Array = [] # for loc in TranslationServer.get_loaded_locales():
	var translation: Translation = TranslationServer.get_translation_object("en")
	if translation:
		var message: PackedStringArray = translation.get_message_list() # get_all_scripts()
		result.append_array(message)
	return result

func search_entry(entry: String) -> int:
	var res: int = Def.INT
	var size: int = len(locale)
	var cr: Array = [[1, 2], [size - (size % 2), -2]]
	while (cr[0][0] < size) and (cr[1][0] > 0) and (res == Def.INT):
		for c in cr:
			if with(c[0], entry): res = c[0]
			c[0] += c[1]
	return res

func align_cursor(res: int, entry: String) -> int:
	assert(res != Def.INT, "Level localization not found")
	while (res != Def.INT and with(res, entry)): res -= 1
	res += 1
	return res

func get_chat(level: int) -> int:
	var entry: String = "L%d" % level
	return align_cursor(search_entry(entry), entry)



func chat(who: String, key: String):
	var statement: Label = PreloadBus.chat.instantiate()
	statement.say(who, key)
	return statement

func chats(who: String, result: Array, key: String, count: int) -> void:
	for i in range(count): result.append(chat(who, key))

func insert_chat(h: Label, p: Label) -> void:
	hud.chat.insert(h)
	panel.insert(p) # .chat

func add_chat(nodes: Array) -> void:
	hud.temp.chat.append(nodes[0])
	hud.chat.append(nodes[1]) # add_child
	panel.append(nodes[2]) # chat

func hide_emotion() -> void: for e in emotion: e.hide_animation()
func set_emotion(id: Dictionary) -> void:
# id.alias.to_lower()
	for e in emotion: e.set_animation('r' + "_" + id.face)
