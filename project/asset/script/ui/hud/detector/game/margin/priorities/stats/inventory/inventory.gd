extends VSplitContainer

@onready var ability: VSplitContainer = $ability
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

func _ready() -> void: drag_started.connect(topic.update_stack)
