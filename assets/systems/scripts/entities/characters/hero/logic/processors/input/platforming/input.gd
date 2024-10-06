extends Node

const NEUTRAL: int = 0
const PERIOD: float = 0.025
const FREEZE: float = 0.075

var time: float = PERIOD
var surface: TileMapLayer

@onready var hero: Node = $direction
@onready var floors: Node = $floors
@onready var ledges: Node = $ledges

func _platforming() -> void:
	#if hero.direction != Vector2i.ZERO:
	time += FREEZE
	floors.perform(surface)
	ledges.perform(surface)

func _physics_process(delta: float) -> void:
	time -= delta
	#print("TIME: ", time)
	if time <= NEUTRAL:
		time = PERIOD
		_platforming()
