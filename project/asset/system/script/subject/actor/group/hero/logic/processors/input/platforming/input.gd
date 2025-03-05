extends Node

const FRAME: float = 0.025
const FREEZE: int = 3

@onready var gap: Node = $gap
@onready var upland: Node = $upland

var ledges: TileMapLayer
var time: float = 0

func _platforming() -> void:
	time = 0
	if (gap.jump_on(ledges) or upland.jump_on(ledges)):
		time -= FRAME * FREEZE

func _physics_process(delta: float) -> void:
# func _process(delta: float) -> void:
	time += delta
	if time >= FRAME:
		_platforming()
