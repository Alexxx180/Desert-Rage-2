extends Node

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
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/blend/left.tscn")
}

func _add_child(query: SoundtrackTreeQuery, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func _set_child(query: SoundtrackTreeQuery, child) -> SoundtrackTreeQuery:
	var caption: String = query.caption
	_add_child(query, child, true).caption = caption 
	return query

func set_alarm(board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	var named: Dictionary = query.decide("name")
	for track in named:
		var path: String = named[track]
		_add_child(query, _alarm).set_metadata(path) # THEME TO NAMED

func set_blend(board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	var named: Dictionary = query.decide("set")
	for track in named:
		var path: String = named[track]
		_add_child(query, _blend[query.pad]).set_metadata(path) # THEME TO NAMED

func set_named(board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	var named: Dictionary = query.decide("name")
	for track in named:
		var path: String = named[track]
		var branch: Button = _add_child(query, _named)
		branch.set_metadata(path)
		branch.set_title(track) # THEME TO NAMED

func set_trunks(setup: Node, board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	setup.enumerate(_set_child(query, _trunk).copy("right").select("type"))
	setup.enumerate(query.copy("left").select("name"))

func set_branch(setup: Node, board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	setup.enumerate(_set_child(query, _branch[query.pad]).select("type"))

func set_themes(board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	for track in query.decide("set"):
		_add_child(query, _theme).set_metadata(track)

func set_combat(board: BehaviorBlackboard) -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	for track in query.decide("set"):
		var branch: Control = _add_child(query, _fight)
		for status in track:
			branch.content[status].set_metadata(track[status])
