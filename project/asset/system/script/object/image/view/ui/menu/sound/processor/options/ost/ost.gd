extends Node

@onready var level: Node = $level
@onready var world: Node = $world

var menu: VBoxContainer

func switch_mode() -> void: menu.switch_mode()

func setup(options: Node) -> void:
	level.setup(options)
	world.setup(options)

func _feedback(options: Node, type: int, select: Array[String]) -> Callable:
	return func():
		options.operation.set_type(type)
		options.play.get(select.front()).call()
		menu.options.get(select.back()).call()

func feedback_edit(options: Node, type: int) -> Callable:
	return _feedback(options, type, ["pause", "switch_skip"])
	
func feedback_play(options: Node) -> Callable:
	return _feedback(options, options.operation.PLAY, ["start_play", "switch_play"])

func setup_edit_mode(options: Node) -> void:
	var group: Array[Button] = menu.options.mode.edit.options
	for i in len(group):
		group[i].pressed.connect(feedback_edit(options, i))

func set_playback(options: Node, ui: HBoxContainer) -> void:
	ui.play.pressed.connect(feedback_play(options))
	ui.forward.pressed.connect(options.play.play_progress)

func setup_play_mode(options: Node) -> void:
	menu.options.play.restart.pressed.connect(options.play.board.reset)
	set_playback(options, menu.options.mode.play)

func setup_modes(options: Node, ui: VBoxContainer) -> void:
	menu = ui
	setup_edit_mode(options)
	setup_play_mode(options)
