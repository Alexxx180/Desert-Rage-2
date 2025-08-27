extends BoxContainer

signal show_toggle(state: bool)

@onready var tabs: BoxContainer = $tabs
@onready var chat: PanelContainer = $scroll/list/chat
@onready var log: PanelContainer = $scroll/list/log

enum { NONE = -1, FIRST = 0, SECOND = 1 }

var opened: int = NONE
var minimized: bool = false

func toggles(prev: Control, next: Control) -> void:
	prev.hide()
	next.show()

func set_view(next: bool) -> void:
	visible = !next
	show_toggle.emit(next)
	minimized = next

func hide_to_panel() -> void: set_view(true)
func show_from_panel() -> void: set_view(false)

func hides() -> void: if not minimized: super.hide()
func shows() -> void: if not minimized: super.show()

func _ready() -> void:
	tabs.get_node("toggle").pressed.connect(hide_to_panel)
	tabs.get_node("game").pressed.connect(func():
		if opened == SECOND:
			log.visible = !log.visible
		else:
			toggles(chat, log)
			opened = SECOND)
	tabs.get_node("chat").pressed.connect(func():
		if opened == FIRST:
			chat.visible = !chat.visible
		else:
			toggles(log, chat)
			opened = FIRST)
