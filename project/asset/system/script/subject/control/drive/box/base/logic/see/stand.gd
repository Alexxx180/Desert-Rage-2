extends Area2D

signal entered(hero)
signal exited(hero)

var box: PhysicsBody2D
var seat: Node

func get_ledge_position() -> Vector2: # print("POS: ", _box.position + position)  # + Vector2(0, 30)
	return box.position + position

func set_entered(hero) -> void: entered.emit(hero)
func set_exited(hero) -> void: exited.emit(hero)
