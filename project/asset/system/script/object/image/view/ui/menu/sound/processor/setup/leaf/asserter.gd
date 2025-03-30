extends Node

const PATH: String = "res://asset/resource/media/ost/manifest.json"

func get_list(user: Dictionary, copy: Dictionary) -> Array:
	return user.values() if user.size() > 0 else copy.values()

func get_leaf(user: Dictionary, copy: Dictionary) -> Dictionary:
	return user if user.has("set") and user.set.size() > 0 else copy

func decide(key: String, user: Dictionary, copy: Dictionary) -> Variant:
	return user[key] if user.has(key) else copy[key]

func get_manifest() -> Dictionary:
	var text: String = FileAccess.open(PATH, FileAccess.READ).get_as_text()
	var processor: JSON = JSON.new()
	if processor.parse(text) == OK:
		return processor.data
	return Defaults.DICT
