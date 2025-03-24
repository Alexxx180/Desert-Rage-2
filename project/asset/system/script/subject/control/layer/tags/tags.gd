extends TileMapLayer

@export var invisible: bool = true
@export var manual: BooksManual

@onready var transition: Node = $transition
@onready var lockers: Node = $lockers
@onready var books: Node = $books
@onready var curtain: Node = $curtain
@onready var execute: TileMapLayer = get_node("../execute")

func _ready() -> void:
	lockers.setup(self, execute)
	transition.setup(self, execute)
	books.setup(self, execute)
	if invisible: hide()
