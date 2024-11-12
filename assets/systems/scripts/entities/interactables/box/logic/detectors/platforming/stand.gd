extends Area2D

var _box: CharacterBody2D
var box: CharacterBody2D:
	get: return _box
	set(next): _box = next

func get_ledge_position():
	# print("POS: ", _box.position + position)
	return _box.position + position
