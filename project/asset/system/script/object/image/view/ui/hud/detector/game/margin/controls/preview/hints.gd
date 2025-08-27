extends BoxContainer

signal show_toggle(state: bool)

@onready var tabs: BoxContainer = $tabs
@onready var help: PanelContainer = $content/help
@onready var books: PanelContainer = $content/books

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
	tabs.get_node("analyze").pressed.connect(func():
		if opened == SECOND:
			help.visible = !help.visible
		else:
			toggles(books, help)
			opened = SECOND)
	tabs.get_node("books").pressed.connect(func():
		if opened == FIRST:
			books.visible = !books.visible
		else:
			toggles(help, books)
			opened = FIRST)
