extends Node

const NEUTRAL: int = 0

@onready var input: Node = get_node("../input")
@onready var platform = get_node("../../detectors/platform/ledge/platforming")
@onready var combo: Timer = $combo

var hero: CharacterBody2D

"""
func _physics_process(_delta):
	if not hero.control: return
	var x: float = input.x
	var y: float = input.y
	if x != NEUTRAL or y != NEUTRAL:
		var direction: Vector2i = input.direction(x, y)
		print("Direction: ", direction)
		platform.perform_jump(direction)
"""

var direction: Vector2i = Vector2i.ZERO

func _platforming():
	combo.stop()
	if direction == Vector2i.ZERO: return
	#var act: Vector2i = direction #.normalized()
	# print("Act: ", direction)
	platform.perform_jump(direction)
	direction = Vector2.ZERO

func _input(_event):
	if not hero.control: return
	var x: float = input.x
	var y: float = input.y
	if x != NEUTRAL: direction.x = int(x)
	if y != NEUTRAL: direction.y = int(y)
	# print("Direction: ", direction)
	combo.start() # diagonal jumps support
	# _platforming() # straight jumps only
# """
