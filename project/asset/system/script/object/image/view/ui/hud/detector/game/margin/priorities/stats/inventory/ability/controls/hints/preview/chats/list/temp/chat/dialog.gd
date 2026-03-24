extends VBoxContainer

@onready var timer: Timer = $timer
@onready var chat: Array[Label] = [
	$queued/margin/label, $answer/margin/label
]
@onready var panel: Array[PanelContainer] = [$queued, $answer]

var capacity: int = 0
var messages: Array[String]

func restart() -> void:
	var length: float = messages[0].length()
	timer.stop()
	timer.wait_time = 2.0 + length / 48.0
	timer.start()
	"""
	print("capacity: ", 0)
	print("message: ", messages[0])
	print("wait: ", timer.wait_time)
	"""

func sync_messages() -> void:
	var length: int = 2
	var count: int = min(capacity, length)
	for i in range(1, count + 1):
		panel[length - i].show()
		chat[length - i].text = messages[count - i]

func add_blocks(plot: Array[String]) -> void:
	for block in plot: add_block(block)
	print("messages: ", messages)
	print("capacity: ", capacity)

func add_block(text: String) -> void:
	messages.push_back(text)
	capacity += 1
	#panel[2 - capacity].show()
	if capacity == 1:
		sync_messages()
		restart()

func free_capacity() -> void:
	messages.pop_front()
	capacity -= 1
	if capacity < 2:
		panel[1 - capacity].hide()
	if capacity == 0:
		timer.stop()
	else:
		sync_messages()
		restart()
