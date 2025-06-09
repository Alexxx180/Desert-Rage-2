extends Area2D

signal entered(hero)
signal exited(hero)

var _box: PhysicsBody2D
var box: PhysicsBody2D:
	get: return _box
	set(next): _box = next

var seat: Node

func get_ledge_position() -> Vector2:
	# print("POS: ", _box.position + position)
	return _box.position + position # + Vector2(0, 30)

func set_entered(hero) -> void: entered.emit(hero)
func set_exited(hero) -> void: exited.emit(hero)
