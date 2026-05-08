extends CanvasLayer

@onready var tree: SceneTree = get_tree()

var fire: bool = false
var whip: bool = false
var stats: SessionStats

func init_options() -> void:
	var options: VFlowContainer = get_node("hud/game")
	var exit: Button = get_node("exit")
	options.finish.pressed.connect(game_continue)
	options.start.pressed.connect(game_start)
	exit.pressed.connect(game_exit)

func _ready() -> void:
	pass#init_options()

func game_exit() -> void: tree.quit() # stats
func game_start() -> void: print_debug(tree.change_scene_to_file(LoadBus.first_level))
func game_continue() -> void: if not stats.load_progress(): stats.load_scene(LoadBus.first_level)
