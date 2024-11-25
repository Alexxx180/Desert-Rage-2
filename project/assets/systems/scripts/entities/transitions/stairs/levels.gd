extends Node

const assets: String = "res://assets/systems/scenes/levels/%s/%s/%d/level.tscn"

func complete_path() -> String:
	var level: Vector2i = Session.location["level"]
	var caption: String = Session.location["name"]

	var f: String = ""

	if (level.x > 0):
		f = "+/"
	elif (level.x < 0):
		f = "-/"
		level.x = abs(level.x)

	return assets % [caption, f + str(level.x), level.y]
