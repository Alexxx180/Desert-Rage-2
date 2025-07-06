extends Node

@onready var gap: Node = $gap
@onready var upland: Node = $upland

var ledges: TileMapLayer
var jumped: bool = false

func _input(_event: InputEvent) -> void:
	jumped = gap.jump_on(ledges) or upland.jump_on(ledges)
