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

func _intersect():
	if use_y:
		pass
	else:
		pass
