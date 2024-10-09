extends Area2D

var _box: StaticBody2D
var box: StaticBody2D:
	get: return _box
	set(next):
		print("!!!!")
		_box = next

func get_ledge_position():
	return box.position + position
