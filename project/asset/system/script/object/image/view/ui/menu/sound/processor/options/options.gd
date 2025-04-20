extends Node

@onready var operation: Node = $operation
@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

var ui: Dictionary

func set_leaf_theme(entry: Dictionary, leaf: Control) -> void:
	operation.set_leaf_theme(self, entry, leaf)

func set_ambient_theme(entry: Dictionary, leaf: Control) -> void:
	operation.set_ambient_theme(self, entry, leaf)

func set_named_theme(entry: Dictionary, leaf: Control) -> void:
	operation.set_named_theme(self, entry, leaf)

func set_standalone(entry: Dictionary, leaf: Control) -> void:
	operation.set_standalone(self, entry, leaf)

func set_blend_theme(entry: Dictionary, leaf: Control) -> void:
	operation.set_blend_theme(self, entry, leaf)

func setup_search(options: Control) -> void:
	var group: Array[Button] = options.search.options
	var i: int = group.size()
	while i > 0:
		i -= 1
		group[i].pressed.connect(func():
			operation.type = i
			options.switch_skip())
	options.play.pressed.connect(func():
		play.play_progress()
		operation.type = 3
		options.switch_play())
	options.skip.pressed.connect(play.play_progress)

func set_operations(menu: VBoxContainer) -> void:
	var theme: OpenThemeDialog = $theme
	add.context = theme
	search.theme = theme
	setup_search(menu.options)
	play.playback.connect(func(status): menu.playback.text = status)
	play.board.progress.connect(func(value): menu.progress.value = value)

func setup() -> void:
	ost.setup(self)
	play.set_ost(ost)
