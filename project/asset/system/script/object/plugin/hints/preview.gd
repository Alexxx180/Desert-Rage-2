extends Resource

class_name HelpPreview

# Dictionary[string, Dictionary[string, bool]]
@export var help: Dictionary = _get_help(func(_f, _a): return false)

func _get_fields() -> Dictionary:
	return {
		"motion": ["move", "jump", "push", "land"]
	}

func _get_help(value: Callable) -> Dictionary:
	var fields: Dictionary = _get_fields()
	var result: Dictionary = {}
	for field in fields.keys():
		result[field] = {}
		for act in fields[field]:
			result[field][act] = value.call(field, act)
	return result

func clone() -> Dictionary:
	return _get_help(func(f, a): return help[f][a])
