extends CollisionShape2D

@export var has_center: bool = false

const gap: int = 3

var ledges: Array[bool]
var track: Array[float]

var boxes: Array[Node2D]
var ends: Array[bool]

func calculate():
	pass
	
func _cancel_ledge(_body: StaticBody2D):
	boxes.pop_back()
	#ledges[body.index] = false

func front(hero: float, box: float) -> bool: return hero > box
func back(hero: float, box: float) -> bool: return hero < box

func jump(hero: CharacterBody2D):
	var side
	match hero.direction:
		"left": side = front
		"right": side = back

	for box in boxes:
		if side.call(hero.position, box.position):
			hero.position.x = box.position.x

func protrusion(i: int, axis: float) -> bool:
	return track[i] - gap < axis and axis < track[i] + gap

func remember(body: StaticBody2D, ledge: bool):
	if ledge: boxes.push_back(body)

func intersect(body: StaticBody2D):
	var size: int = track.size() - 1
	var ledge: bool = protrusion(size, body.position.x)
	while not ledge and size >= 0:
		size -= 1
		ledge = protrusion(size, body.position.x)
	remember(body, ledge)
