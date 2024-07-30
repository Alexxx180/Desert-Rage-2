extends Area2D

@export_range(2, 3) var edges: int = 2

@onready var track = $track

@export var has_center: bool = false
@export var use_y: bool = false

var ledges: Array[bool]

func _ready():
	if edges == 2:
		ledges = [false, false]
	else:
		ledges = [false, has_center, false]

func _on_track(body: Node2D):
	if body is CharacterBody2D:
		track.jump(body)
	elif body is StaticBody2D:
		track.intersect(body)
