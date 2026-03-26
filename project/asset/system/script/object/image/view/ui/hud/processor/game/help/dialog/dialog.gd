extends Node

@onready var timer: Timer = $timer

var cursor: DialogCursor = DialogCursor.new()
var length: int = 0
var locale: Node
var nodes: Array = []

var who: Dictionary = { "R": "RAY", "K": "ROCK", "D": "DID", "Q": "???" }
var face: Dictionary = {
	"L": "look", "R": "rage", "G": "grin", "S": "smile", "C": "confirm",
	"T": "tired", "B": "but", "N": "sign", "A": "amaze", "P": "respect",
	"E": "anger", "Y": "play", "I": "rain", 
}

func set_level(value: int) -> void: cursor.set_level(value, locale.get_chat(value))
func scroll() -> void: cursor.scroll(locale)
func _ready() -> void: timer.timeout.connect(talking)

func add_chat(part: int) -> void:
	var key: String = "L%d_%d" % [cursor.level, part]
	cursor.add_queue(locale, key)
	timer.start()

func get_chatter(key: String) -> Dictionary:
	assert(face.has(key[-1]), "Unknown emotion: %s" % key)
	assert(who.has(key[-2]), "Unknown character: %s" % key)
	return { "face": face[key[-1]], "who": who[key[-2]] }

func _new_chat_block() -> void:
	var key: String = locale.text(cursor.chat)
	var id: Dictionary = get_chatter(key)
	length = len(key) ; nodes.clear()
	cursor.block.chats(id.who, nodes, key, 3)
	cursor.block.add_chat(key)
	cursor.block.set_emotion(id)

func plot_speech() -> void:
	for node in nodes: node.visible_characters += 1
	length -= 1

func talking() -> void:
	if length > 0:
		plot_speech()
	elif cursor.talking:
		_new_chat_block()
	else:
		timer.stop()
