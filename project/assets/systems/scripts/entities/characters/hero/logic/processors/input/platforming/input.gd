extends Node

const NEUTRAL: int = 0
const PERIOD: float = 0.025
const FREEZE: float = 0.075

var time: float = PERIOD
var gap: TileMapLayer
var upland: TileMapLayer

@onready var hero: Node = $direction
@onready var floors: Node = $floors
@onready var ledges: Node = $ledges

func _platforming() -> void:
	if hero.direction != Vector2i.ZERO:
		time += FREEZE
		floors.perform(gap)
		ledges.perform(upland)

func _physics_process(delta: float) -> void:
	time -= delta
	if time <= NEUTRAL:
		time = PERIOD
		_platforming()