extends HBoxContainer

@onready var tabs: VBoxContainer = $tabs
@onready var help: PanelContainer = $content/help
@onready var books: PanelContainer = $content/books

enum { NONE = -1, FIRST = 0, SECOND = 1 }

var opened: int = NONE

func toggle(prev: Control, next: Control) -> void:
	prev.hide()
	next.show()

func _ready() -> void:
	tabs.get_node("analyze").pressed.connect(func():
		if opened == SECOND:
			help.visible = !help.visible
		else:
			toggle(books, help)
			opened = SECOND)
	tabs.get_node("books").pressed.connect(func():
		if opened == FIRST:
			books.visible = !books.visible
		else:
			toggle(help, books)
			opened = FIRST)
