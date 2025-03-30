extends Node

var _trunk = preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/trunk/trunk.tscn")
var _branch: Dictionary = {
	"left": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/left.tscn"),
	"right": preload("res://asset/system/scene/object/image/view/ui/menu/sound/detector/dropdown/tree/branch/right.tscn")
} 

func _get_item(caption: String, item) -> HBoxContainer:
	var trunk: Control = item.instantiate()
	trunk.caption = caption
	return trunk

func set_trunk(list: VBoxContainer, caption: String) -> HBoxContainer:
	var context: HBoxContainer = _get_item(caption, _trunk)
	list.add_child(context)
	return context

func set_branch(list: VBoxContainer, caption: String, pad: String) -> HBoxContainer:
	var context: HBoxContainer = _get_item(caption, _branch[pad])
	list.add_child(context)
	return context
