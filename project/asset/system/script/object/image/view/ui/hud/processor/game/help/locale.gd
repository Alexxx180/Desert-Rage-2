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

func get_chat(level: int) -> int:
	var entry: String = "L%d" % level
	var res: int = Defaults.INT ; var i: int = 1
	var size: int = len(locale) ; var j: int = size - (size % 2)
	while (i < size) and (j > 0) and (res == Defaults.INT):
		if text(i).begins_with(entry): res = i
		if text(j).begins_with(entry): res = i
		i += 2 ; j -= 2
	assert(res != Defaults.INT, "Level localization not found")
	return res
