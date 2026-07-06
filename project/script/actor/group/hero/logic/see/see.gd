extends Node2D

@onready var world: RayCast2D = $world

var _fight: Node2D = null
var fight: Node2D:
	get: return Works.upload(self, _fight, LoadBus.fight, "fight")

var casual: bool = true
var dir: Vector2i = Vector2i(0, 1)

func set_direction(direction: Vector2i) -> void:
	if direction != Vector2i.ZERO:
		dir = direction
	world.set_direction(direction)
	if not casual:
		fight.set_direction(direction)
