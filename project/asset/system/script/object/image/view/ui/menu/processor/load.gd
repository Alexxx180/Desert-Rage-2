extends Node

#@onready var timer: Timer = $show
@onready var tree = get_tree()

@export_file var scene: String = "res://asset/system/scene/usable/level/caves/origin/0/0/level.tscn"

func _scene_change() -> void:
	# timer.stop()
	print_debug(tree.change_scene_to_file(scene))
	#print_debug(tree.call_deferred("change_scene_to_file", scene))
