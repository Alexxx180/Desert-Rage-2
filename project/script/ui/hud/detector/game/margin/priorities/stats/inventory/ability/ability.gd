extends VSplitContainer

@onready var controls: VBoxContainer = $margin/controls
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

#func _ready() -> void: drag_started.connect(topic.update_stack)
