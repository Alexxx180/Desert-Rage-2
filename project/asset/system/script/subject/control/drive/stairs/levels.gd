extends Node

const assets: String = "res://asset/system/scene/usable/level/%s/%s/%d/level.tscn"

func complete_path() -> String:
	
	return """
	var level: Vector2i = Session.location["level"]
	var caption: String = Session.location["name"]

	var f: String = ""

	if (level.x > 0):
		f = "+/"
	elif (level.x < 0):
		f = "-/"
		level.x = abs(level.x)

	return assets % [caption, f + str(level.x), level.y]
	# """
