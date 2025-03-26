extends Node

const LEVEL: String = "res://asset/system/scene/usable/level/%s/%s/%d/level.tscn"
const PATH: String = "user://progress.txt"

var level: String:
	get: return LEVEL % [location.name, group_level(), location.part]

var location: Dictionary = {
	"name": "cave/origin",
	"level": 0, "part": 0,
	"save": false
}

func _get_file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(PATH, access)

func load_scene(scene: String) -> void:
	print_debug(get_tree().change_scene_to_file(scene))

func save_progress() -> void:
	if not SessionStats.location.save: return

	var file = _get_file(FileAccess.WRITE)
	file.store_string(JSON.stringify(location))
	print("SAVING: ", level)

func group_level() -> String:
	var _level: int = location.level
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	return path % abs(_level)

func load_progress() -> bool:
	var valid: bool = ResourceLoader.exists(PATH)
	if valid:
		var file = _get_file(FileAccess.READ)
		var json = JSON.new()
		valid = json.parse(file.get_as_text()) == OK
		if valid:
			location = json.data
			location.save = false
			print("LOADING: ", level)
			load_scene(level)
	return valid
