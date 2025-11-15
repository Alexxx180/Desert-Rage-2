extends HBoxContainer

@onready var next: HBoxContainer = $next
@onready var priority: Label = next.get_node("priority")

func set_next_priority(caption: String) -> void:
	priority.text = caption
	next.show()
