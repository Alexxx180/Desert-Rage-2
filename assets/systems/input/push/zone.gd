extends CollisionShape2D

var previous: Vector2
var entity: Node2D

@export var gap: Array = [[-2, 2], [-2, 2]]
@onready var walls: StaticBody2D = $walls
@onready var timer: Timer = $feedback

func _ready():
	entity = get_parent()
	while "moveable" in entity:
		entity = entity.moveable
	print(entity.position)
	previous = entity.position
	#print('entity: ', entity.name)

func _come_off():
	walls.process_mode = Node.PROCESS_MODE_DISABLED
	timer.stop()

func _push_forward(initial: Vector2, force: Vector2, velocity: int):
	var desk: Array = [initial.x, initial.y]
	var hero: Array = [force.x, force.y]

	for i in range(0, 2):
		var distance: float = desk[i] - hero[i]
		"""
		if i == 1:
			print("Y-DISTANCE: ", distance)
		if i == 0:
			print("X-DISTANCE: ", distance)
		"""
		
		if distance > gap[i][0] and distance < gap[i][1]:
			previous = entity.position
			match i:
				0: entity.position.x += velocity
				1: entity.position.y += velocity
			#break

func _block_pushing():
	walls.process_mode = Node.PROCESS_MODE_INHERIT
	entity.position = previous
	timer.start()

func _on_push(hero: Node2D):
	print("hmm x2")
	if walls.process_mode == Node.PROCESS_MODE_INHERIT: return

	if not hero is CharacterBody2D:
		_block_pushing()
	else:
		var power: int = hero.push * hero.additional_force()
		#print("RIGHT BOTTOM")
		_push_forward(entity.rightpos, hero.position, -power)
		#print("TOP LEFT")
		_push_forward(entity.position, hero.rightpos, power)

func _on_interaction(_block: Area2D):
	print("hmm")
	_block_pushing()
