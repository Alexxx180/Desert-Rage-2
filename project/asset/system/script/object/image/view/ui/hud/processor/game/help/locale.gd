extends Node

var _locale: Array
var locale: Array:
	get:
		if _locale == null: _locale = _get_locale()
		return _locale

func text(cursor: int) -> String: return locale[cursor]
func with(cursor: int, start: String) -> bool:
	return locale[cursor].begins_with(start)

func _get_locale() -> Array: # TODOT
	var result: Array = []
	for loc in TranslationServer.get_loaded_locales():
		var translation = TranslationServer.get_translation_object(loc)
		if translation: result.append_array(translation.get_message_list())
	return result

func l(a: String, b: String, entry: String):
	return a.begins_with(entry) or b.begins_with(entry)

func get_chat(level: int) -> void:
	var entry: String = "L%d" % level
	return locale.bsearch_custom(entry, func(a, b): l(a, b, entry))
