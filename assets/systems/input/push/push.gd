extends Node2D

@export var form: String = "."
@export var base: String = "."

var subject: Node2D
var geometry: CollisionShape2D

var basis: Vector2 : get = _get_basis
var right: Vector2 : get = _get_right

func _get_basis() -> Vector2: return subject.position
func _get_right() -> Vector2: return basis + geometry.shape.size
	
func subtract(size: Node2D) -> Array[float]:
	return [right.x - size.basis.x, right.y - size.basis.y]

func _ready():
	subject = get_node(base)
	geometry = get_node(form)
