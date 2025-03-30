extends Node

var _trunk = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/trunk/trunk.tscn")
var _branch: Dictionary = {
	"left": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/left.tscn"),
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/right.tscn")
} 

func set_trunk(list: VBoxContainer, caption: String) -> HBoxContainer:
	var context: HBoxContainer = _trunk.instantiate()
	list.add_child(context)
	context.caption = caption
	return context

func set_branch(list: Container, caption: String, pad: String) -> HBoxContainer:
	var context: HBoxContainer = _branch[pad].instantiate()
	list.add_child(context)
	context.caption = caption
	return context
