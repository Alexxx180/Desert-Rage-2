extends Node

var _theme = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var _fight = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

var _trunk = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/trunk/trunk.tscn")
var _branch: Dictionary = {
	"left": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/left.tscn"),
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/right.tscn")
} 

func set_alarm(ui: Control, context: Dictionary) -> void:
	pass

func set_blend(ui: Control, context: Dictionary) -> void:
	pass

func set_named(ui: Control, context: Dictionary) -> void:
	pass

func set_trunk(ui: Control, caption: String, copy: Dictionary, user: Dictionary) -> void:
	var context: HBoxContainer = trunk.set_trunk(ui, caption)
	var typed: Variant = asserter.decide("type", user, copy)
	var named: Variant = asserter.decide("name", user, copy)
	enumerate_group(context.content.head.content.body, copy.type, typed, "right")
	enumerate_group(context.content.body, copy.name, named, "left")

func set_trunks(ui: Control, context: Dictionary) -> void:
	var board: BehaviorBlackboard
	var setup: Node = board.get_value("setup")
	var typed: Node = board.get_value("query").copy("right")
	var named: Node = board.get_value("query")
	setup.enumerate(query.select("type"))
	setup.enumerate(query.select("name"))
	

	var list: VBoxContainer
	var caption: String
	# var pad: String
	var context1: HBoxContainer = _trunk.instantiate()
	list.add_child(context1)
	context.caption = caption
	pass

func set_branch(ui: Control, context: Dictionary) -> void:
	var caption: String
	var pad: String
	var list: VBoxContainer
	var context1: HBoxContainer = _branch[pad].instantiate()
	list.add_child(context1)
	context1.caption = caption

	pass

func set_themes(list: VBoxContainer, track: String) -> void:
	var leaf: Control = _theme.instantiate()
	list.add_child(leaf)
	leaf.set_metadata(track)

func set_combat(list: VBoxContainer, tracks: Dictionary) -> void:
	var combat: Control = _fight.instantiate()
	list.add_child(combat)
	for status in ["ambient", "heating", "rampage"]:
		combat.content[status].set_metadata(tracks[status])


func set_branch(ui: Control, caption: String, copy: Dictionary, user: Dictionary, pad: String) -> void:
	var context: HBoxContainer = trunk.set_branch(ui, caption, pad)
	enumerate_group(context.content.body, copy, user, pad)

func set_trunk(ui: Control, caption: String, copy: Dictionary, user: Dictionary) -> void:
	var context: HBoxContainer = trunk.set_trunk(ui, caption)
	var typed: Variant = asserter.decide("type", user, copy)
	var named: Variant = asserter.decide("name", user, copy)
	enumerate_group(context.content.head.content.body, copy.type, typed, "right")
	enumerate_group(context.content.body, copy.name, named, "left")
	#set_music(context.content.head.content.body, "type", copy.type, typed, "right")
	#set_music(context.content.body, "name", copy.name, named, "left")

func enumerate_tracks(ui: Control, copy: Variant, user: Variant, pad: String) -> void:
	for key in copy:
		set_music(ui, key, copy[key], asserter.decide(key, user, copy), pad)

func enumerate_group(ui: Control, copy: Variant, user: Variant, pad: String) -> void:
	if copy.has("set"):
		leaf.determine_combat(ui, asserter.get_leaf(user, copy))
	elif copy.values()[0] is String:
		leaf.set_themes(ui, asserter.get_list(user, copy))
	else:
		enumerate_tracks(ui, copy, user, pad)

func set_music(ui: Control, caption: String, copy: Dictionary, user: Dictionary, pad: String) -> void:
	#if copy.has("set"):
		#leaf.determine_combat(ui, asserter.get_leaf(user, copy)) # ui.content.body
	#el
	if copy.has("type"):
		set_trunk(ui, caption, copy, user)
	else:
		set_branch(ui, caption, copy, user, pad)

func set_soundtrack(ui: HFlowContainer) -> void:
	var copy: Dictionary = asserter.get_manifest()
	if copy == Defaults.DICT: return
	
	var user: Dictionary = copy
	var pad: String = "left"
	for key in ["level", "world"]:
		var context: HBoxContainer = trunk.set_branch(ui, key, pad)
		enumerate_group(context.content.body, copy[key], asserter.decide(key, user, copy), pad)
		#context.size_flags_horizontal = Control.SIZE_EXPAND_FILL
