extends Node

class_name EntitySize

var _subject: Callable
var shape: Vector2

var basis: Vector2: get = _basis
var right: Vector2: get = _right

func _basis() -> Vector2: return _subject.call()
func _right() -> Vector2: return basis + shape

func sub(size: EntitySize) -> Vector2:
	return right - size.basis

func set_control_entity(subject: Node2D) -> void:
	_subject = func() -> Vector2: return subject.position
	shape = subject.geometry.shape.size
