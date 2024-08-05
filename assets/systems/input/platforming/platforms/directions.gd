extends Node2D

@onready var box: Node2D = get_node("../..")
@onready var horizontal: CollisionShape2D = $horizontal/track
@onready var vertical: CollisionShape2D = $vertical/track

func _init(direction: Node2D):
	direction.track.route = { box.name : box }

func _ready():
	for direction in [horizontal, vertical]:
		_init(direction)

func determine_jump(hero: CharacterBody2D):
	for direction in [horizontal, vertical]:
		direction.jump(hero)
