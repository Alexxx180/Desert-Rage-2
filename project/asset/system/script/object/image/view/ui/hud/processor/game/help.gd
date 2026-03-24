extends InputObserver

var list: VBoxContainer

func add_log() -> void:
	pass

func _l(a: String, b: String, entry: String):
	if a.begins_with(entry): return true
	return b.begins_with(entry)

func ready(lvl: int):
	var entry: String = "L" + lvl
	var banana = ["Banana", 5]
	my_items.insert(my_items.bsearch_custom(banana, sort_by_amount, false), banana)
	print(my_items)

func add_chat(queue: Array) -> void:
	var level: int = queue.bsearch_custom(entry, func(a, b): _l(a, b, entry))
	
