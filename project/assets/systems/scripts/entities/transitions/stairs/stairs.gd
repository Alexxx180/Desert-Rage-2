extends Area2D

var _is_finishing: bool = false

@export var fallback_scene: String = ""

@export var direction: int = 1

@onready var levels: Node = $levels
@onready var interval: Node = $interval
@onready var transition: CanvasLayer = $transition

func _finish(_hero: CharacterBody2D) -> void:
	if _is_finishing: return
	_is_finishing = true
	
	if fallback_scene != "":
		transition.start_transition(fallback_scene)
		return
	#Processors.turn(hero.view, false)
	#Processors.turn(hero.logic, false)
	print("FALLBACK: ", fallback_scene)
	
	Session.location["level"].x += direction
	Session.location["level"].y = interval.part

	var path: String = levels.complete_path()
	transition.start_transition(path)

func _ready() -> void:
	if fallback_scene != "": return
	
	var level: Vector2i = Session.location["level"]
	interval.set_stairs_position(level.y, position)
