extends Area2D

@export_range(2, 3) var edges: int = 2

@export var has_center: bool = false
@export var use_y: bool = false

var ledges: Array[bool]

func _ready():
	if edges == 2:
		ledges = [false, false]
	else:
		ledges = [false, has_center, false]

func step_and_jump(hero: CharacterBody2D):
	
	hero.platforming.x
	pass

func _on_track(body: Node2D):
	if body is CharacterBody2D:
		pass
	elif body is CharacterBody2D:
		track.intersect(body)
		pass
