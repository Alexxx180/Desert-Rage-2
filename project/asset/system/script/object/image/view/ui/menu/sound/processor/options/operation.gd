extends Node

enum { DROP = 0, ADD = 1, SET = 2, PLAY = 3 }

var _type: int = -1
var type: int:
	get: return _type
	set(value): _type = value

func set_leaf_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.pressed.connect(func():
		match type:
			DROP: options.drop.from_theme(entry, leaf)
			ADD: options.add.to_theme(self, entry, leaf)
			SET: options.search.for_theme(entry, leaf)
			PLAY: options.play.as_theme(entry, leaf)
	)

func set_ambient_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	for status in leaf.content:
		leaf.content[status].pressed.connect(func():
			match type:
				DROP: options.drop.from_theme(entry, leaf)
				ADD: options.add.to_ambient(self, entry, leaf)
				SET: options.search.for_ambient(entry, status, leaf)
				PLAY: options.play.as_ambient(entry, status, leaf)
		)

func set_named_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_named(entry, leaf)
			PLAY: options.play.as_named(entry, leaf)
	)

func set_blend_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_blend(entry, leaf)
			PLAY: options.play.as_blend(entry, leaf)
	)
