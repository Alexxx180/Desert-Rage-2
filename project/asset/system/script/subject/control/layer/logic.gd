extends TileMapLayer

@export var invisible: bool = true

@onready var activators: Node = $activators
@onready var transition: Node = $transition
@onready var curtain: Node = $curtain

func set_stats() -> void:
	var path: String = get_parent().name.trim_prefix("map")
	
	var i: int = path.find("-", 1)
	var level: int = int(path.substr(0, i))
	var part: int = int(path.substr(i + 1))
	
	SessionStats.location.level = Vector2i(level, part)
	print("path: ", path, ", floor: ", level, ", part: ", part)

func _ready() -> void:
	set_stats()
	
	transition.teleport.fill(self, get_node("../execute"))
	
	var level: Node = transition.level
	level.next_level.connect(curtain.start_transition)
	level.next_level.connect(transition.check.next_level_transition)
	
	if invisible: hide()
