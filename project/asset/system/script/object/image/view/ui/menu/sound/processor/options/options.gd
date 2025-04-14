extends Node

@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

var ui: Dictionary

func set_leaf_theme(entry: Dictionary, leaf: Control) -> void:
	leaf.pressed.connect(func():
		drop.from_theme(entry, leaf)
		play.as_theme(entry, leaf)
		add.to_theme(entry, leaf)
		search.for_theme(entry, leaf)
	)

func set_ambient_theme(entry: Dictionary, leaf: Control) -> void:
	for status in leaf.content:
		leaf.content[status].pressed.connect(func():
			drop.from_theme(entry, leaf)
			search.for_ambient(entry, status, leaf)
			add.to_ambient(entry, leaf)
			play.as_ambient(entry, leaf)
		)

func set_named_theme(entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		search.for_theme(entry, leaf)
		play.as_named(entry, leaf)
	)

func setup(options: HBoxContainer) -> void:
	options.drop.toggled.connect(drop.on_toggle)
	options.add.toggled.connect(add.on_toggle)
	options.search.toggled.connect(search.on_toggle)
	ost.setup(self)
	play.set_ost(ost)
