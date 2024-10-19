extends Area2D

var _box: StaticBody2D
var box: StaticBody2D:
	get: return _box
	set(next): _box = next

func get_ledge_position():
	return _box.position + position
