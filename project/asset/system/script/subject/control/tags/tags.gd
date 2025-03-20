extends TileMapLayer

@export var invisible: bool = true

@onready var transition: Node = $transition
@onready var lockers: Node = $lockersW
@onready var curtain: Node = $curtain

func _ready() -> void:
	var execute: TileMapLayer = get_node("../execute")
	lockers.setup(self, execute)
	transition.setup(self, execute)
	if invisible: hide()
