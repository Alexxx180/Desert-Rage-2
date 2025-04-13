extends Node

@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play

var ui: Dictionary

func set_leaf_theme(entry: Dictionary) -> void:
	var leaf: Button = entry.ui[entry.i]
	leaf.pressed.connect(func():
		drop.from_theme(entry)
		play.as_theme(entry)
		add.to_theme(entry)
		search.for_theme(entry)
	)

func set_ambient_theme(entry: Dictionary) -> void:
	var ambient: HBoxContainer = entry.ui[entry.i]
	for status in ambient.content:
		var leaf: Button = ambient.content[status]
		leaf.pressed.connect(func():
			drop.from_theme(entry)
			search.for_ambient(entry, status)
			add.to_ambient(entry)
			play.as_ambient(entry)
		)

func set_named_theme(entry: Dictionary) -> void:
	var named: Button = entry.ui[entry.i]
	print("ENTRY UI: ", entry.ui)
	named.pressed.connect(func():
		print("NAMED THEME SET")
		search.for_theme(entry)
		play.as_named(entry)
	)

func setup(options: HBoxContainer) -> void:
	options.drop.toggled.connect(drop.on_toggle)
	options.add.toggled.connect(add.on_toggle)
	options.search.toggled.connect(search.on_toggle)
	play.set_playback(self)
