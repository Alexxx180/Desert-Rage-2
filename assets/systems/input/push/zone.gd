extends CollisionShape2D

var is_pushing: bool = false
var previous: Vector2
var entity: Node2D

@export var gap: int = 2
@onready var walls: StaticBody2D = $walls
@onready var timer: Timer = $feedback

func _ready():
	entity = get_parent()
	while "moveable" in entity:
		entity = entity.moveable
	previous = entity.position

func _come_off():
	walls.process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()

func _push_forward(initial: Vector2, force: Vector2, velocity: int):
	if is_pushing: return

	var desk: Array = [initial.x, initial.y]
	var hero: Array = [force.x, force.y]
	var i: int = 0

	while i < 2 and not is_pushing:
		var distance: float = desk[i] - hero[i]
		is_pushing = distance > -gap and distance < gap
		i += 1
		
	if is_pushing:
		previous = entity.position
		match i - 1:
			0: entity.position.x += velocity
			1: entity.position.y += velocity

func _block_pushing():
	walls.process_mode = Node.PROCESS_MODE_INHERIT
	entity.position = previous
	timer.start()
	is_pushing = false

func _on_push(hero: Node2D):
	if walls.process_mode == Node.PROCESS_MODE_INHERIT: return

	var is_hero: bool = hero is CharacterBody2D
	
	if not is_hero and is_pushing:
		_block_pushing()
	elif is_hero:
		is_pushing = false
		var power: int = hero.push * hero.additional_force()
		_push_forward(entity.rightpos, hero.position, -power)
		_push_forward(entity.position, hero.rightpos, power)
