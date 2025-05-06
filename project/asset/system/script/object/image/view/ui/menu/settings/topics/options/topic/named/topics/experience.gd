extends VBoxContainer

@onready var sound: VBoxContainer = $sound
@onready var experience: VBoxContainer = $experience
@onready var interface: VBoxContainer = $interface
@onready var stats: VBoxContainer = $stats
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [sound.get_node("header"), stats.get_node("header"),
		experience.get_node("header"), interface.get_node("header"),
		sound.options.music.submit, stats.get_node("header")]
