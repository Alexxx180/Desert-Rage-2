extends Node

signal no_manifest(file: String)
signal setup()

@onready var open: OpenPresetDialog = $open
@onready var _reader: ZIPReader = ZIPReader.new()

func _from_path(folder: DirAccess, file: String) -> String:
	return folder.get_current_dir().path_join(file)

func _set_one(folder: DirAccess, path: String) -> void:
	folder.make_dir_recursive(_from_path(folder, path).get_base_dir())
	var file: FileAccess = FileAccess.open(_from_path(folder, path), FileAccess.WRITE)
	file.store_buffer(_reader.read_file(path))

func _copy_files() -> void:
	var user: DirAccess = DirAccess.open("user://")
	for file in _reader.get_files():
		var path: String = file.replace("user://", "")
		if path.ends_with("/"):
			user.make_dir_recursive(path)
		else:
			_set_one(user, path)
	setup.emit()

func _extract(path: String) -> void:
	print("IMPORTING")
	var manifest: String = "music.json"
	
	_reader.open(path)
	if _reader.file_exists(manifest):
		_copy_files()
	else:
		print("NO MANIFEST!")
		no_manifest.emit(manifest)
	
	_reader.close()

func importing():
	open.show_dialog(_extract)
