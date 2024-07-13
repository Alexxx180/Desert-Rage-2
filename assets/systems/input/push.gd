extends Area2D

var power: int = 4
var right: Vector2
var left: Vector2

func _ready():
	var size: Vector2 = $interaction.shape.size
	left = position - size
	right = position + size

func _push_vertical(tackle: int):
	position.x += tackle
	right.x += tackle
	left.x += tackle

func _push_horizontal(tackle: int):
	position.y += tackle
	right.y += tackle
	left.y += tackle

func _on_push(hero: Node2D):
	print('move')
	if hero.position.x > right.x:
		print('left')
		position.x -= power
		right.x -= power
		left.x -= power
	elif hero.position.x < left.x:
		print('right')
		position.x += power
		left.x += power

	if hero.position.y > right.y:
		print('left')
		position.y -= power
	elif hero.position.y < left.y:
		print('right')
		position.y += power
	#position.x += 10
	#position = move_toward(Vector2(0, 200000), 15)
	#move_and_collide(Vector2())
