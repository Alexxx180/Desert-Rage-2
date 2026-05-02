extends Timer

enum { DROP = 1, DIFFUSION = 5, LENGTH = 10 }

var spark: Dictionary = {}
var cells: Array[Vector2i] = []
var size: int = 0
var conductor: FlowConductor

func _ready() -> void: timeout.connect(lazy_diffusion)

func set_puddle(cell: Vector2i, status: String, resize: int) -> void:
	conductor.set_puddle(cell, status)
	size = resize

func diffuse_puddle(item: int) -> void:
	var map_coords: Vector2i = cells[item]
	if spark[map_coords] <= 0:
		set_puddle(map_coords, "OFF", size - 1)
		spark.erase(map_coords)
		cells.remove_at(item)

func not_in_spark(cell: Vector2i, _c = Def.DICT) -> bool: return not cell in spark

func lazy_sparking(map_coords: Vector2i) -> void:
	var can_place: bool = conductor.around(map_coords, {}, not_in_spark)
	if can_place:
		set_puddle(map_coords, "ON", size + 1)
		spark[map_coords] = DIFFUSION
		cells.append(map_coords)
	if size == 1: start()

func lazy_diffusion() -> void:
	var i: int = cells.size()
	while i > 0:
		i -= 1
		spark[cells[i]] -= DROP
		diffuse_puddle(i)
	if size == 0: stop()
