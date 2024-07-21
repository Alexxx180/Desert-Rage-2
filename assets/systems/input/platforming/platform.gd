extends Area2D

@export_range(0, 9) var current_floor: int = 0
@export_range(1, 2) var height: int = 1

@onready var platforming: Timer = $platforming

var ledge: Dictionary
var hero: CharacterBody2D

func _ready():
	ledge = {
		"left": get_node($left.opposite),
		"right": get_node($right.opposite),
		"forward": get_node($forward.opposite),
		"backward": get_node($backward.opposite),
	}

func compare(ledge_floor: int) -> bool:
	return current_floor + height == ledge_floor

func _on_control():
	var i: int = 0
	var jumped: bool = false
	var reach: bool = false
	
	var directions: Array[String] = ["left", "right", "forward", "backward"]
	var direction: String
	
	while not (jumped and reach) and i < 3:
		direction = directions[i]
		jumped = Input.is_action_pressed(direction)
		reach = ledge[direction].is_same_floor()
		#print("DIRECTED: ", direction, ", Jumped: ", jumped, ", Reach: ", reach)
		i += 1

	platforming.stop()

	if jumped and reach:
		hero.jump(direction)
		hero = null
	else:
		platforming.start()

func _on_step(body: Node2D):
	#print("PLATFORMING")
	if body is CharacterBody2D:
		#print("ON PLATFORM")
		hero = body
		platforming.start()
