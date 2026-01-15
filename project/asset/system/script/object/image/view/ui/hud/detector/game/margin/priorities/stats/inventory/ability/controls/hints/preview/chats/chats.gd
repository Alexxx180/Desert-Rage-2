extends BoxContainer

signal show_toggle(state: bool)

@onready var tabs: BoxContainer = $log/tabs
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

func set_toggle(no: int, a: PanelContainer, b: PanelContainer) -> void:
	if opened == no:
		a.visible = !a.visible
	else:
		toggles(b, a)
		opened = no

func _ready() -> void:
	tabs.get_node("toggle").pressed.connect(hide_to_panel)
	# TODO FIXME TOGGLE LOGS
	#tabs.get_node("game").pressed.connect(func(): set_toggle(SECOND, log, chat))
	#tabs.get_node("chat").pressed.connect(func(): set_toggle(FIRST, chat, log))
