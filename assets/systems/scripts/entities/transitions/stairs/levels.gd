extends Node

const assets: String = "res://assets/levels/%s/%s/%d/level.tscn"

func complete_path() -> String:
	var level: Vector2i = Session.location["level"]

	var f: String = str(level.x)

	if (level.x > 0):
		f = '+/' + f
	elif (level.x < 0):
		f = '-/' + f

	return assets % [Session.location["name"], f, level.y]
