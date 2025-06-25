extends TileMapLayer

@export var invisible: bool = true
@export var manual: BooksManual
@export var foe: Array[String] = [""]
@export var boss: String = ""

@onready var transition: Node = $transition
@onready var lockers: Node = $lockers
@onready var books: Node = $books
@onready var enemy: Node = $enemy
@onready var curtain: Node = $curtain
@onready var execute: TileMapLayer = get_node("../execute")
@onready var push: TileMapLayer = get_node("../push")

func _ready() -> void:
	lockers.setup(self, execute)
	transition.setup(self, execute)
	books.setup(self, execute)
	enemy.setup(self, push)
	if invisible: hide()
