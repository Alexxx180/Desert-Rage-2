extends MarginContainer

@onready var timer: Timer = $timer
@onready var chat: Array[Label] = [
	$queued/margin/label,
	$answer/margin/label
]

var capacity: int = 0
var messages: Array[String]

func restart() -> void:
	var length: int = messages[capacity - 1].length()
	timer.stop()
	timer.wait_time = 2 + length / 12
	timer.start()

func sync_messages() -> void:
	for i in range(1, 2):
		chat[-i].text = messages[capacity - i]
	restart()

func add_block(text: String) -> void:
	messages.push_back(text)
	capacity += 1
	if capacity > 2: return
	chat[-capacity].show()
	chat[-capacity].text = messages[capacity - 1]
	restart()

func free_capacity() -> void:
	messages.pop_front()
	capacity -= 1
	if capacity == 0: timer.stop()
	if capacity < 2:
		chat[capacity - 1].hide()
		return
	sync_messages()
	
