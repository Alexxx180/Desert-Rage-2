extends SoundtrackQuery

class_name ExportOST

var result: Variant
var path: String

func set_user(user: Dictionary) -> void:
	_user = user

func set_path(file: String) -> void:
	path = file

func copy() -> ExportOST:
	var query = ExportOST.new()
	query.set_user(_user)#.duplicate())
	query.set_path(path)
	query.result = result# .duplicate()
	return query
	#return self

func get_path(track: String) -> String:
	return path + track.substr(track.rfind("/") + 1) #  + "/"

func set_alarm() -> ExportOST:
	result[caption] = []
	result = result[caption]
	return self

func set_branch() -> ExportOST:
	result[caption] = {}
	result = result[caption]
	return self

func select(branch: String) -> ExportOST:
	_user = _user[branch]
	path += branch + "/"
	caption = branch
	return self
