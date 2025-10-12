extends Node

var theme = preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/leaf/leaf.tscn")
var fight = preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/leaf/combat.tscn")

var alarm = preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/leaf/alarm.tscn")
var named = preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/leaf/named.tscn")

var trunk = preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/trunk/trunk.tscn")
var branch: Dictionary = {
	"left": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/branch/left.tscn"),
	"right": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/branch/right.tscn")
}
var mix: Dictionary = {
	"left": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/mix/left.tscn"),
	"right": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/mix/right.tscn")
}
var blend: Dictionary = {
	"left": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/blend/left.tscn"),
	"right": preload("res://asset/system/scene/object/canvas/ui/menu/sound/detector/dropdown/tree/blend/right.tscn")
}
