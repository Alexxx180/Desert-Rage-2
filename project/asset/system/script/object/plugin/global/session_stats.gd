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

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	location.level = int(path.substr(0, i))
	location.part = int(path.substr(i + 1))
	location.save = true
	print("Session stats assign: ", location)

func _file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(PATH, access)

func load_scene(scene: String) -> void:
	print_debug(get_tree().change_scene_to_file(scene))

func save_progress() -> void:
	if location.save:
		_file(FileAccess.WRITE).store_string(JSON.stringify(location))

func group_level(diff: int = 0) -> String:
	var _level: int = location.level + diff
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	return path % abs(_level)

func _parseable(text: String) -> bool:
	var processor: JSON = JSON.new()
	var parsed: bool = processor.parse(text) == OK
	if parsed:
		location = processor.data
		location.save = false
		load_scene(level)
	return parsed

func load_progress() -> bool:
	var exist: bool = FileAccess.file_exists(PATH)
	return exist and _parseable(_file(FileAccess.READ).get_as_text())
