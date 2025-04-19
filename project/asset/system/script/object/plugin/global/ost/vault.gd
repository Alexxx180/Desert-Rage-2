extends RefCounted

class_name Vault

static func copy(from: String, to: String, force: bool = false) -> void:
	var dir: DirAccess = DirAccess.open("user://")
	if force or not dir.file_exists(to):
		dir.copy(from, to)

static func get_json(path: String, feedback: Callable) -> Dictionary:
	if not FileAccess.file_exists(path):
		return Defaults.DICT
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	if processor.parse(text) == OK:
		feedback.call(true)
		return processor.data
	else:
		return Defaults.DICT

static func set_json(path: String, value: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var json: String = JSON.stringify(value)
	file.store_string(json)
