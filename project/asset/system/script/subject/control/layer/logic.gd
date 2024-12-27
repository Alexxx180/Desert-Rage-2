extends TileMapLayer

@export var invisible: bool = true

@onready var activators: Node = $activators
@onready var transition: Node = $transition
@onready var curtain: Node = $curtain

func _ready() -> void:
	var path: String = get_parent().name.trim_prefix("map")
	
	var i: int = path.find("-", 1)
	var level: int = int(path.substr(0, i))
	var part: int = int(path.substr(i + 1))
	
	SessionStats.location.level = Vector2i(level, part)
	print("path: ", path, ", floor: ", level, ", part: ", part)
	transition.tags = self
	
	if invisible: hide()
