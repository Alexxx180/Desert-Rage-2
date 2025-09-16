extends TileMapLayer

@export var invisible: bool = true
@export var manual: BooksManual
@export var foe: Array[String] = [""]
@export var boss: String = ""
@export var casual_mode: bool = false

@onready var transition: Node = $transition
@onready var lockers: Node = $lockers
@onready var books: Node = $books
@onready var enemy: Node = $enemy
@onready var curtain: Node = $curtain
@onready var chests: Node = $chests
@onready var level: Dictionary = {
	"border": get_node("../border"), "execute": get_node("../execute"), "tags": self
}
# @onready var push: TileMapLayer = get_node("../push")

func _ready() -> void:
	lockers.setup(level)
	transition.setup(self, level.border)
	books.setup(level)
	enemy.setup(self, level.execute, casual_mode)
	chests.setup(self, casual_mode)
	if invisible: hide()
