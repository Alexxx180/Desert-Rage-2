extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

func floor_only(control: Node, _gap: TileMapLayer) -> void:
	print("floor jump")
	feet.deploy()
	control.available = false

func determine(control: Node, border: TileMapLayer) -> void:
	print("determine jump")
	if ledges.around():
		feet.jump(ledges.pos)
	else:
		feet.deploy(border)
	feet.set_midair(control)
