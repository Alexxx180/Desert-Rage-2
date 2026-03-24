extends VBoxContainer

@onready var chat: PanelContainer = $chat
@onready var logs: PanelContainer = $logs
@onready var temp: VBoxContainer = $temp

func add_log() -> void:
	pass

func sort_by_amount(a, b):
	if a[1] < b[1]:
		return true
	return false

func _ready():
	var my_items = [["Tomato", 2], ["Kiwi", 5], ["Rice", 9]]

	var apple = ["Apple", 5]
	# "Apple" is inserted before "Kiwi".
	my_items.insert(my_items.bsearch_custom(apple, sort_by_amount, true), apple)

	var banana = ["Banana", 5]
	# "Banana" is inserted after "Kiwi".
	my_items.insert(my_items.bsearch_custom(banana, sort_by_amount, false), banana)

	# Prints [["Tomato", 2], ["Apple", 5], ["Kiwi", 5], ["Banana", 5], ["Rice", 9]]
	print(my_items)


from bisect import bisect_left
func word_exists(keys: Array, word_fragment):
	keys.bsearch_custom()
	try:
		return wordlist[bisect_left(wordlist, word_fragment)].startswith(word_fragment)
	except IndexError:
		return False # word_fragment is greater than all entries in wordlist


func add_chat(queue: Array) -> void:
	pass
