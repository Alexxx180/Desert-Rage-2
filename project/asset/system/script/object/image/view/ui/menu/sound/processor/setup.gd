extends Node

@onready var leaf: Node = $leaf
@onready var branch: Node = $branch
@onready var trunk: Node = $trunk
@onready var asserter: Node = $asserter

func set_branch(ui: Control, caption: String, copy: Dictionary, user: Dictionary, pad: String) -> void:
	var context: HBoxContainer = trunk.set_branch(ui, caption)
	enumerate_tracks(context.content.body, copy, user, pad)

func set_trunk(ui: Control, caption: String, copy: Dictionary, user: Dictionary) -> void:
	var context: HBoxContainer = trunk.set_trunk(ui, caption)
	var typed: Dictionary = asserter.decide("type", user, copy)
	var named: Dictionary = asserter.decide("name", user, copy)
	enumerate_tracks(context.content.head.content.body, copy.type, typed, "right")
	enumerate_tracks(context.content.body, copy.name, named, "left")

func enumerate_tracks(ui: Control, copy: Dictionary, user: Dictionary, pad: String) -> void:
	for key in copy:
		set_music(ui, key, copy[key], asserter.decide(key, user, copy), pad)

func set_music(ui: Control, caption: String, copy: Dictionary, user: Dictionary, pad: String) -> void:
	if copy.has("set"):
		leaf.determine_combat(ui.content.body, asserter.get_leaf(user, copy))
	elif copy.has("type"):
		set_trunk(ui, caption, copy, user)
	else:
		set_branch(ui, caption, copy, user, pad)

func set_soundtrack(detector: Control) -> void:
	var copy: Dictionary = {}
	var user: Dictionary = copy
	var ui: Control = detector.tracks
	for key in ["level", "world"]:
		set_branch(ui, key, copy[key], asserter.decide(key, user, copy), "left")
