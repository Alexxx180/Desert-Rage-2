extends TileMapLayer

@export var invisible: bool = true

@onready var activators: Node = $activators
@onready var transition: Node = $transition
@onready var curtain: Node = $curtain

func _ready() -> void:
	var execute: TileMapLayer = get_node("../execute")
	activators.setup(execute)
	transition.setup(self, execute)
	if invisible: hide()
