extends Node

var _locale: Array = Def.ARRAY
var locale: Array:
	get:
		if _locale == Def.ARRAY: _locale = _get_locale()
		return _locale

func text(cursor: int) -> String: return locale[cursor]
func with(cursor: int, start: String) -> bool:
	return locale[cursor].begins_with(start)

func _get_locale() -> Array: # TODOT
	var result: Array = [] # for loc in TranslationServer.get_loaded_locales():
	var translation: Translation = TranslationServer.get_translation_object("en")
	if translation:
		var message: PackedStringArray = translation.get_message_list() # get_all_scripts()
		result.append_array(message)
	return result

func search_entry(entry: String) -> int:
	var res: int = Def.INT
	var size: int = len(locale)
	var cr: Array = [[1, 2], [size - (size % 2), -2]]
	while (cr[0][0] < size) and (cr[1][0] > 0) and (res == Def.INT):
		for c in cr:
			if with(c[0], entry): res = c[0]
			c[0] += c[1]
	return res

func align_cursor(res: int, entry: String) -> int:
	assert(res != Def.INT, "Level localization not found")
	while (res != Def.INT and with(res, entry)): res -= 1
	res += 1
	return res

func get_chat(level: int) -> int:
	var entry: String = "L%d" % level
	return align_cursor(search_entry(entry), entry)
