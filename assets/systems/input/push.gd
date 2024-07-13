extends Area2D

var power: int = 4
var right: Vector2

func _ready():
	right = position + $interaction.shape.size

func _push_horizontal(tackle: int):
	position.x += tackle
	right.x += tackle

func _push_forward(tackle: int):
	position.y += tackle
	right.y += tackle

func _push(vertical: Vector2, side: int):
	if vertical.y > -power and vertical.y < power:
		_push_forward(power * side)
	elif vertical.x > -power and vertical.x < power:
		_push_horizontal(power * side)

func _on_push(hero: Node2D):
	var bottom: Vector2 = Vector2(right.x - hero.position.x, right.y - hero.position.y)
	var top: Vector2 = Vector2(position.x - hero.right.x, position.y - hero.right.y)

	_push(bottom, -1)
	_push(top, 1)
