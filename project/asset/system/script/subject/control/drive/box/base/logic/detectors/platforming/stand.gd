extends Area2D

var _box: PhysicsBody2D
var box: PhysicsBody2D:
	get: return _box
	set(next): _box = next

var seat: Node

func get_ledge_position() -> Vector2:
	# print("POS: ", _box.position + position)
	return _box.position + position
