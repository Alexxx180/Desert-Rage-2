extends Node

signal move(next: Vector2)

const INVERSE: Vector2 = Vector2(-1, -1)

@export var track: Vector2 = Vector2(-250, 0)

@onready var staying: Timer = $staying

var speed: float = 1
var platform: CharacterBody2D
var stay: bool = false
var starting: bool = false

func _ready() -> void: staying.timeout.connect(wait)

func inverse_track() -> void: track *= INVERSE

func near_ledge() -> bool:
	return platform.logic.see.ledge.is_colliding()

func wait() -> void: 
	inverse_track()
	stay = false
	starting = true

func push(motion: Vector2) -> void:
	platform.velocity = motion * speed # platform.position
	# print("SET VELOCITY TO: ", motion * speed)
	#move.emit(platform.ledge)#logic.see.stand.get_ledge_position())

func _set_motion(motion: Vector2) -> void:
	if stay:
		motion = Vector2.ZERO
		staying.start()
	push(motion)

func process() -> void:
	if starting:
		starting = near_ledge()
		_set_motion(track)
	elif not stay:
		stay = near_ledge()
		_set_motion(track)
