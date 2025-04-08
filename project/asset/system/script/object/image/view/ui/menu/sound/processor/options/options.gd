extends Node

@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $set
@onready var play: Node = $play

var ui: Dictionary
var progress: Dictionary

func connect_ui(group: Array, tracks: Array, i: int, progress: Dictionary) -> void:
	var button: Control = group[i]
	button.pressed.connect(func():
		drop.delete_theme(group, tracks, i)
		play.play_theme(group, tracks, i)
		add.add_theme(group, tracks, i)
		search.search_theme(group, tracks, i)
	)
