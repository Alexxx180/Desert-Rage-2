extends Control

enum { MAX = 45, OFFSET = 30, DEGREE = 60 }

var centered: Rect2
var portion: Array[float] = []

@export_range(3, 20, 1) var sides: int = 6

var colors: Dictionary = {
	"line": Color8(28, 28, 53, 255), "polygon": Color8(25, 25, 25, 255),
	"dots": [Color8(127, 127, 127, 255), Color8(78, 78, 156, 255), Color8(135, 135, 255, 255)]
}

var default: Dictionary = { "hp": 11, "ap": 10, "power": 6,
	"influence": 7, "vitality": 3, "reaction": 6 }
var adds: Array[int] = [1, 2, 1, 3, 1, 2]

func set_stats(stats: Dictionary) -> void:
	for p in ["vitality", "reaction", "ap", "influence", "power", "hp"]:
		portion.append(stats[p] / float(MAX))

func _ready() -> void:
	centered = Rect2(custom_minimum_size / 2, custom_minimum_size)
	set_stats(default)

func draw_point(point: Vector2, add: int) -> void:
	if add == 0: return
	add = min(colors.dots.size(), add)
	var dot: Color = colors.dots[add - 1]
	add = min(2, add)
	draw_rect(Rect2(point, Vector2(add, add)), dot)

func _draw() -> void:
	var pts: PackedVector2Array = get_hex()
	draw_colored_polygon(pts, colors.polygon)
	draw_polyline(pts, colors.line, 1)
	var j: int = 0
	for i in range(0, len(pts), 2):
		draw_point(pts[i], adds[j])
		j += 1

func get_hex() -> PackedVector2Array:
	var pts: PackedVector2Array = []
	var pos: Vector2 = hex_corner(0)
	pts.append(pos)
	for i in range(1, sides):
		var iside: Vector2 = hex_corner(i)
		pts.append(iside)
		pts.append(iside)
	pts.append(pos)
	return pts
	
func hex_corner(i: int) -> Vector2:
	var rad: float = deg_to_rad(DEGREE * i - OFFSET)
	return centered.position + portion[i] * centered.size * Vector2(cos(rad), sin(rad))
