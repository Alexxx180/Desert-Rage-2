extends Node

@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

enum { DROP = 0, ADD = 1, SET = 2, PLAY = 3 }

var ui: Dictionary
var _operation: int = -1
var operation: int:
	get: return _operation
	set(value): _operation = value

func set_leaf_theme(entry: Dictionary, leaf: Control) -> void:
	leaf.pressed.connect(func():
		match operation:
			DROP: drop.from_theme(entry, leaf)
			ADD: add.to_theme(self, entry, leaf)
			SET: search.for_theme(entry, leaf)
			PLAY: play.as_theme(entry, leaf)
	)

func set_ambient_theme(entry: Dictionary, leaf: Control) -> void:
	for status in leaf.content:
		leaf.content[status].pressed.connect(func():
			match operation:
				DROP: drop.from_theme(entry, leaf)
				ADD: add.to_ambient(self, entry, leaf)
				SET: search.for_ambient(entry, status, leaf)
				PLAY: play.as_ambient(entry, status, leaf)
		)

func set_named_theme(entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match operation:
			SET: search.for_named(entry, leaf)
			PLAY: play.as_named(entry, leaf)
	)

func setup_search(options: Control) -> void:
	var group: Array[Button] = options.search.get_options(options.play)
	var i: int = group.size()
	while i > 0:
		i -= 1
		group[i].pressed.connect(func(): operation = i)

func setup(menu: VBoxContainer) -> void:
	setup_search(menu.options)
	ost.setup(self)
	play.set_ost(ost)
	play.board.progress.connect(func(value):
		menu.progress.value = value)
