extends TileMapLayer

@export var invisible: bool = true
@onready var activators: Node = $activators

func _ready() -> void: if invisible: hide()
