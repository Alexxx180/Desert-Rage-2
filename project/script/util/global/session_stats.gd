class_name SessionStats extends RefCounted

var xp: RefCounted
var tree: SceneTree
var level: String:
	get: return Def.level % [location.name, group_level(), location.part]

var location: Dictionary = {
	"name": "cave/origin",
	"level": 0, "part": 0,
	"save": false
}
var progress: PackedInt32Array

func _init(t: SceneTree) -> void: tree = t

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	location.level = int(path.substr(0, i))
	location.part = int(path.substr(i + 1))
	location.save = true
	print("Session stats assign: ", location)

func _file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(Def.progress, access)

func load_scene(scene: String) -> void:
	print_debug(tree.change_scene_to_file(scene))

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
	var exist: bool = FileAccess.file_exists(Def.progress)
	return exist and _parseable(_file(FileAccess.READ).get_as_text())

func _ready() -> void:
	pass
	#var options: VBoxContainer = get_node("../hud/back/options")
	#options.continue.pressed.connect()
	#options.start.pressed.connect(game_start)

func game_exit() -> void: tree.quit()
func game_start() -> void: load_scene(Def.first_level)
func game_continue() -> void: if not load_progress(): load_scene(Def.first_level)
