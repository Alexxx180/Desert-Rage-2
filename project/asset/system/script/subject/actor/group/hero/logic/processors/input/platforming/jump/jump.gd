extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

func ready() -> void:
	ledges.space.same_level = feet.same_level

func floor_only(control: Node, _gap: TileMapLayer) -> void:
	feet.deploy()
	control.available = false

func determine(control: Node, border: TileMapLayer) -> void:
	if ledges.around():
		feet.jump(ledges.pos)
	else:
		feet.deploy(border)
	feet.set_midair(control)
