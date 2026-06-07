class_name Vault extends RefCounted

static func copy(from: String, to: String, force: bool = false) -> void:
	var dir: DirAccess = DirAccess.open("user://")
	print("COPY FROM? ", from)
	if force:
		print("FORCE DELETE: ", to, " = ", dir.remove(to))
	if not dir.file_exists(to):
		print("COPY! ", to, " = ", dir.copy(from, to))

static func _parse_json(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	return { "json": processor, "result": processor.parse(text) == OK }

static func get_json(path: String, feedback: Callable) -> Dictionary:
	if not FileAccess.file_exists(path): return {}

	var parsed: Dictionary = _parse_json(path)
	if not parsed.result: return {}
	
	feedback.call(true)
	return parsed.json.data

static func set_json(path: String, value: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var json: String = JSON.stringify(value)
	file.store_string(json)
