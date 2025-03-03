extends Node

const ID: int = 2
const SOURCE: Vector2i = Vector2i(1, 3)
var tiles = {
	"PUDDLE": Vector2i(0, 2),
	"SPARK": [Vector2i(1, 2), SOURCE]
}

var count: int = 0
var _execute: TileDecorator
var execute: TileDecorator:
	get: return _execute
	set(value):
		_execute = value
		charge.execute = value
		chains.initiate(execute.busy(SOURCE, ID))

@onready var drain: Node = $drain
@onready var charge: Node = $charge
@onready var chains: Node = $chains

func _ready() -> void:
	charge.flow.connect(puddle)

func at_edge(previous: Rect2i) -> bool:
	return execute.context.coords - previous.position == previous.size
