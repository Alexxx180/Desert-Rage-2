extends TileMapLayer

@export var manual: BooksManual
@export var invisible: bool = true
@export var casual_mode: bool = false
@export_group("Enemies")
@export_flags_3d_physics var monsters: int
@export_flags_3d_navigation var bosses: int

@onready var transition: Node = $transition
@onready var lockers: Node = $lockers
@onready var books: Node = $books
@onready var enemy: Node = $enemy
@onready var curtain: Node = $curtain
@onready var chests: Node = $chests
@onready var lay: Node = $lay
# @onready var push: TileMapLayer = get_node("../push")

func _ready() -> void:
	lockers.location.activator.trigger.chests = chests
	lockers.setup(lay)
	transition.setup(lay)
	books.setup(lay)
	enemy.setup(lay, casual_mode)
	chests.setup(lay, casual_mode)
	if invisible: hide()
