extends HBoxContainer

@onready var tabs: VBoxContainer = $tabs
@onready var chat: PanelContainer = $scroll/list/chat
@onready var log: PanelContainer = $scroll/list/log

func _ready() -> void:
	tabs.get_node("game").pressed.connect(func():
		chat.hide(); log.show())
	tabs.get_node("chat").pressed.connect(func():
		chat.show(); log.hide())
