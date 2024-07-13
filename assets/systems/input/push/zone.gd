extends CollisionShape2D

var previous: Vector2
var entity: Node2D

@export var power: int = 4
@export var gap: float = 4

@onready var walls: StaticBody2D = $walls
@onready var timer: Timer = $feedback

func _ready():
	entity = get_parent()
	while "moveable" in entity:
		entity = entity.moveable

func _come_off():
	walls.process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()
	print("PROBLEM")

func _push_forward(initial: Vector2, force: Vector2, velocity: int):
	var desk: Array = [initial.x, initial.y]
	var hero: Array = [force.x, force.y]
	
	for i in range(0, 2):
		var distance: float = desk[i] - hero[i]
		if distance > -gap and distance < gap:
			previous = entity.position
			match i:
				0: entity.position.x += velocity
				1: entity.position.y += velocity

func _on_push(hero: Node2D):
	if walls.process_mode == Node.PROCESS_MODE_INHERIT:
		return
	
	if not hero is CharacterBody2D:
		walls.process_mode = Node.PROCESS_MODE_INHERIT
		entity.position = previous
		timer.start()
	else:
		_push_forward(entity.rightpos, hero.position, -power)
		_push_forward(entity.position, hero.rightpos, power)
