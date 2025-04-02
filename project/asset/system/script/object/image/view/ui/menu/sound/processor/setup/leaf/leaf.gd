extends Node

@onready var leafs: Node = $leafs

var _theme = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var _alarm = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/alarm.tscn")
var _named = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/named.tscn")
var _fight = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")
var _trunk = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/trunk/trunk.tscn")
var _branch: Dictionary = {
	"left": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/left.tscn"),
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/right.tscn")
}
var _blend: Dictionary = {
	"left": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/blend/left.tscn"),
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/blend/right.tscn")
}

func set_blend(setup: Node, query: SoundtrackTreeQuery) -> void:
	var mix: int = clampi(query.decide("mix"), 0, 100)
	leafs.set_blend(query, _blend, mix)
	leafs.include(query, _named, _set_titled, "set")

func set_trunks(setup: Node, query: SoundtrackTreeQuery) -> void:
	leafs.set_child(query, _trunk)
	setup.enumerate(query.copy("right").select("type"))
	setup.enumerate(query.copy("left").select("name"))

func set_branch(setup: Node, query: SoundtrackTreeQuery) -> void:
	leafs.set_child(query, _branch[query.pad])
	setup.enumerate(query)

func set_alarm(query: SoundtrackTreeQuery) -> void:
	leafs.set_alarm(query, _alarm)

func set_named(query: SoundtrackTreeQuery) -> void:
	leafs.include(query, _named, leafs.set_titled)

func set_themes(query: SoundtrackTreeQuery) -> void:
	leafs.include(query, _theme, leafs.set_theme, "set")

func set_combat(query: SoundtrackTreeQuery) -> void:
	leafs.include(query, _fight, leafs.set_fight, "set")
