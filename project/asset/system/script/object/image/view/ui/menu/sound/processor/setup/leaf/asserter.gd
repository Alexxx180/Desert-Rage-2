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

func select(branch: String) -> void:
	pass
	"""
	var context: HBoxContainer = trunk.set_trunk(ui, caption)
	var typed: Variant = asserter.decide("type", user, copy)
	var named: Variant = asserter.decide("name", user, copy)
	enumerate_group(context.content.head.content.body, copy.type, typed, "right")
	enumerate_group(context.content.body, copy.name, named, "left")
	"""
