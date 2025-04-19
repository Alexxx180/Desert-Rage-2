extends Node

@onready var _writer: ZIPPacker = ZIPPacker.new()

func manifest(result: Dictionary) -> void:
	print("RESULT: ", result)
	_writer.start_file("music.json")
	_writer.write_file(JSON.stringify(result, "\t").to_utf8_buffer())
	_writer.close_file()

func write(source: String, destination: String) -> void:
	print("WRITING: ", source, " + ", destination)
#	"""
	if FileAccess.file_exists(source):
		print("FILE EXISTS!!!")
		var file: FileAccess = FileAccess.open(source, FileAccess.READ)
		_writer.start_file(destination)
		_writer.write_file(file.get_buffer(file.get_length()))
		_writer.close_file()
		file.close()

func start_write(path: String) -> int:
	return _writer.open(path)

func stop_write() -> void:
	_writer.close()

func append(query: ExportOST, from: Array, to: Array, i: int) -> void:
	to.push_front(query.get_path(from[i]))
	write(from[i], to[i])

func insert(query: ExportOST, from: Dictionary, to: Dictionary, key: String) -> void:
	to[key] = query.get_path(from[key])
	write(from[key], to[key])

func iterate(query: ExportOST, feedback: Callable) -> void:
	query.result.mix = query.context.mix
	query.result.set = []
	var i: int = query.context.set.size()
	while i > 0:
		i -= 1
		feedback.call(i)
