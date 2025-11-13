extends Control

# @export var center: Vector2 = Vector2(10, 10)
# @export var side: int = 10
const MAX: float = 95
enum {  HP = 1, AP = 2 }

var center: Vector2
var side: int
var portion: Array[float] = []
@export var color: Color = Color8(28, 28, 53, 255)
@export_range(3, 20, 1) var sides: int = 6

# """
var default: Dictionary = { "hp": 0, "ap": 95, "power": 95,
	"influence": 95, "vitality": 95, "reaction": 10 }
"""
var default: Dictionary = { "hp": 20, "ap": 30, "power": 17,
	"influence": 7, "vitality": 20, "reaction": 67 }
# """

func _ready() -> void:
	side = custom_minimum_size.x
	center = custom_minimum_size / 2
	set_stats(default)

func set_stats(stats: Dictionary) -> void:
	for p in ["vitality", "reaction", "ap", "influence", "power", "hp"]:
		portion.append(stats[p] / MAX)

#TODO DRAW
func _draw() -> void: # draw_polyline()
	var pts: PackedVector2Array = get_hex()
	draw_colored_polygon(pts, color)
	print("PTS: ", pts)
	for i in range(1, len(pts), 2):
		draw_circle(pts[i], 2, Color.BLUE)
	draw_circle(pts[-2], 2, Color.BLUE)
	#for pt in pts: #draw_polyline()
"""
[(40.98076, 0.0),
(40.98076, 30.0), (40.98076, 30.0),
(15.0, 45.0), (15.0, 45.0),
(-10.98076, 30.0), (-10.98076, 30.0),
(-10.98076, -0.0), (-10.98076, -0.0),
(15.0, -15.0), (15.0, -15.0),
(40.98076, 0.0)]
"""
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
	var rad: float = deg_to_rad(60 * i - 30) # var angle_rad = PI / 180 * angle_deg
	return center + portion[i] * Vector2(side * cos(rad), side * sin(rad))

"""
func hex_corner(i: int) -> Vector2:
	var rad: float = deg_to_rad(60 * i - 30) # var angle_rad = PI / 180 * angle_deg
	return portion[i] * Vector2(
		center.x + side * cos(rad),
		center.y + side * sin(rad))
"""

"""
In a regular hexagon the interior angles are 120°.
There are six “wedges”, each an equilateral triangle with 60° angles inside.
Each corner is size units away from the center. In code:
	
To fill a hexagon, gather the polygon vertices at hex_corner(…, 0) through hex_corner(…, 5).
To draw a hexagon outline, use those vertices, and then draw a line back to hex_corner(…, 0).
"""
