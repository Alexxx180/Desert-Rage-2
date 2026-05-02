extends CanvasLayer

@onready var tree: SceneTree = get_tree()

var fire: bool = false
var whip: bool = false

var stats: SessionStats
var scene: String = "res://asset/system/scene/usable/level/cave/origin/0/0/level.tscn"

func _ready() -> void:
	pass
	#var options: VBoxContainer = get_node("../hud/back/options")
	#options.continue.pressed.connect()
	#options.start.pressed.connect(game_start)

func game_exit() -> void: stats.tree.quit()

func game_start() -> void:
	print_debug(tree.change_scene_to_file(scene))

func game_continue() -> void:
	if not stats.load_progress():
		stats.load_scene(scene)
