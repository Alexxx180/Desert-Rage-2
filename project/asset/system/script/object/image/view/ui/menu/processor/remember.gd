extends Node

@export_file var scene: String = "res://asset/system/scene/usable/level/cave/origin/0/0/level.tscn"

func scene_change() -> void:
	if not SessionStats.load_progress():
		SessionStats.load_scene(scene)
