extends CollisionShape2D

@export var has_center: bool = false

const gap: int = 3

var ledges: Array[bool]
var track: Array[float]

func calculate():
	pass
	
func _cancel_ledge(body: StaticBody2D):
	ledges[body.index] = false

func protrusion(i: int, axis: float) -> bool:
	return track[i] - gap < axis and axis < track[i] + gap

func intersect(body: StaticBody2D):
	var size: int = track.size() - 1
	var ledge: bool = protrusion(size, body.position.x)
	while not ledge and size >= 0:
		size -= 1
		ledge = protrusion(size, body.position.x)
	if ledge:
		ledges[size] = true
		body.index = size
