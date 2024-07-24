extends Node2D

@onready var ledges: Array[Area2D] = [$left, $right, $forward, $backward]

func _ready():
	var box: Area2D = get_parent()
	for ledge in ledges: ledge.box = box

func jump_to_ledge(body: CharacterBody2D):
	var directions: Array[String] = []
	for ledge in ledges:
		ledge.add_direction(directions)
	body.platforming.coordinate(directions)
	body.set_movement(Node.PROCESS_MODE_DISABLED)
	print("ENABLED")
	body.set_platforming(Node.PROCESS_MODE_INHERIT)
