extends SoundtrackLeaf

@onready var title: Label = $margin/title

#var event: String
var event: int

func set_title(entity: String) -> void:
	title.text = entity

func set_options(options: Node, context: Dictionary) -> void:
	options.set_named_theme(context, self)

func set_feedback(feedback: Callable) -> void:
	pressed.connect(feedback)
