extends Area2D

var power: int = 4
var tackle: float = 4
var box: Dictionary

@onready var walls: StaticBody2D = $walls
@onready var timer: Timer = $feedback

func _ready():
	var right: Vector2 = position + $interaction.shape.size
	box = {
		'axis': 'x', 'touch': 1.2,
		'pos': { 'x': position.x, 'y': position.y },
		'right': { 'x': right.x, 'y': right.y }
	}

func _push() -> float:
	var axis: String = box['axis']
	box['pos'][axis] += tackle
	box['right'][axis] += tackle
	return box['pos'][axis]

func _push_forward(vertical: Vector2, side: int):
	if vertical.y > -power and vertical.y < power:
		box['axis'] = 'y'
		tackle = power * side
		position.y = _push()
		tackle *= -box['touch']
	elif vertical.x > -power and vertical.x < power:
		box['axis'] = 'x'
		tackle = power * side
		position.x = _push()
		#_push_horizontal(resist)
		tackle *= -box['touch']

func _enable(): walls.process_mode = Node.PROCESS_MODE_DISABLED

func _on_push(hero: Node2D):
	if not hero is CharacterBody2D or walls.process_mode == Node.PROCESS_MODE_INHERIT:
		_push()
		walls.process_mode = Node.PROCESS_MODE_INHERIT
		timer.start()
	else:
		var bottom = Vector2(box['right'].x - hero.position.x, box['right'].y - hero.position.y)
		var top = Vector2(position.x - hero.right.x, position.y - hero.right.y)
		_push_forward(bottom, -1)
		_push_forward(top, 1)
