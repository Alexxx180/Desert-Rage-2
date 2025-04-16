extends Node

func _from_path(folder: DirAccess, file: String) -> String:
	return folder.get_current_dir().path_join(file)

func _set_one(folder: DirAccess, reader: ZIPReader, path: String) -> void:
	folder.make_dir_recursive(_from_path(folder, path).get_base_dir())
	var file: FileAccess = FileAccess.open(_from_path(folder, path), FileAccess.WRITE)
	file.store_buffer(reader.read_file(path))

func _extract(path: String) -> void:
	var reader: ZIPReader = ZIPReader.new()
	var user: DirAccess = DirAccess.open("user://")
	reader.open(path)
	for file in reader.get_files():
		if file.ends_with("/"):
			user.make_dir_recursive(file)
		else:
			_set_one(user, reader, file)

func exporting() -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		_extract(metadata.track)
