extends BoxContainer

@onready var tabs: BoxContainer = $tabs
@onready var chat: PanelContainer = $scroll/list/chat
@onready var log: PanelContainer = $scroll/list/log

enum { NONE = -1, FIRST = 0, SECOND = 1 }

var opened: int = NONE

func toggle(prev: Control, next: Control) -> void:
	prev.hide()
	next.show()

func hide_to_panel() -> void:
	pass

func _ready() -> void:
	tabs.get_node("game").pressed.connect(func():
		if opened == SECOND:
			log.visible = !log.visible
		else:
			toggle(chat, log)
			opened = SECOND)
	tabs.get_node("chat").pressed.connect(func():
		if opened == FIRST:
			chat.visible = !chat.visible
		else:
			toggle(log, chat)
			opened = FIRST)
