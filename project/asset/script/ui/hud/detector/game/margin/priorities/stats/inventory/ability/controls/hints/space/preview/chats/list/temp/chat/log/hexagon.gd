extends Control

enum { MAX = 45, OFFSET = 30, DEGREE = 60 }

@export_range(3, 20, 1) var sides: int = 6

@onready var centered: Rect2 = Rect2(custom_minimum_size / 2, custom_minimum_size)

var colors: Dictionary = {
	"line": clr(28, 53), "polygon": clr(25, 25), "dots": [clr(127, 127), clr(78, 156), clr(135, 255)]
}
var portion: Array[float] = []
var adds: Array[int] = []
var points: PackedVector2Array
var show_stats: bool = false
var show_hex: bool = false

func clr(rg: int, b: int) -> Color: return Color8(rg, rg, b, 255)

func set_stats(stats: Array, delta: Array) -> void:
	for p in MakeStats.hexagon():
		portion.append(min(stats[p] / float(MAX), 1))
		adds.append(delta[p])
	set_hex()
	queue_redraw()

func draw_point(point: Vector2, add: int) -> void:
	if add == 0: return
	add = min(colors.dots.size(), add)
	var dot: Color = colors.dots[add - 1]
	add = min(2, add)
	draw_rect(Rect2(point, Vector2(add, add)), dot)

func reveal_stats() -> void:
	show_stats = true
	queue_redraw()

func _draw() -> void:
	if show_hex:
		draw_colored_polygon(points, colors.polygon)
	if show_stats:
		draw_polyline(points, colors.line, 1)
		var j: int = 0
		for i in range(0, len(points), 2):
			draw_point(points[i], adds[j])
			j += 1

func set_hex() -> void:
	points = []
	var pos: Vector2 = hex_corner(0)
	points.append(pos)
	for i in range(1, sides):
		var iside: Vector2 = hex_corner(i)
		points.append(iside)
		points.append(iside)
	points.append(pos)
	show_hex = true
	
func hex_corner(i: int) -> Vector2:
	var rad: float = deg_to_rad(DEGREE * i - OFFSET)
	return centered.position + portion[i] * centered.size * Vector2(cos(rad), sin(rad))
