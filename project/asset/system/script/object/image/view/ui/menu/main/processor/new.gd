extends Node

var scene: String = "res://asset/system/scene/usable/level/cave/origin/0/0/level.tscn"

func scene_change() -> void:
	print_debug(get_tree().change_scene_to_file(scene))
