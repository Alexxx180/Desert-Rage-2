extends Label

var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void: text = priorities[no]
