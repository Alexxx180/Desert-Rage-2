extends Node

const FRAME: float = 0.025
const FREEZE: int = 3

@onready var floors: Node = $floors
@onready var ledges: Node = $ledges

var gap: TileMapLayer
var upland: TileMapLayer
var time: float = 0

func _platforming() -> void:
	time = 0
	if (floors.perform(gap) or ledges.perform(upland)):
		time -= FRAME * FREEZE

func _physics_process(delta: float) -> void:
	time += delta
	if time >= FRAME:
		_platforming()
