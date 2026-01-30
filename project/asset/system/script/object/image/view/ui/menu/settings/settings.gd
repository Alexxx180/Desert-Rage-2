extends CanvasLayer

@onready var see: Panel = $see
@onready var work: Node = $work
@onready var link: Node = $link

func first_focus() -> void: see.first_focus()

func set_transitions(menu: CanvasLayer, sound: CanvasLayer) -> void:
	see.topics.tabs.set_back(self, menu)
	see.topics.options.set_soundtrack_transition(self, sound)

func _ready() -> void:
	see.topics.tabs.caption.set_shortcut(self)
	see.topics.options.set_transition(self)
	link.connect_controls(see, work)
