extends HBoxContainer

@onready var caption: Label = get_node("caption")
@onready var next: HBoxContainer = $next
@onready var priority: Label = next.get_node("priority")

var heroes: Dictionary = { "ray": "Рей", "rock": "Рок" }

func set_caption(hero: String) -> void:
	caption.text = heroes[hero]

func set_next_priority(caption: String) -> void:
	priority.text = caption
	next.show()
