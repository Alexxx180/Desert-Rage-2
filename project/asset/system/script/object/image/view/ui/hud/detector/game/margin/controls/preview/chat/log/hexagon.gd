extends Control

# @export var center: Vector2 = Vector2(10, 10)
# @export var side: int = 10
var center: Vector2
var side: int
@export_range(3, 20, 1) var sides: int = 6

func _ready() -> void:
	side = custom_minimum_size.x
	center = custom_minimum_size / 2

func _draw() -> void: # draw_polyline()
	var pts: PackedVector2Array = get_hex()
	draw_colored_polygon(pts, Color8(28, 28, 53, 200))
	print("PTS: ", pts)
	#for i in range(1, len(pts), 2):
		#draw_line(pts[i], pts[i], Color.BLUE, 3)
	#for pt in pts:
		#draw_polyline()
"""
var pts: PackedVector2Array = [
		Vector2(0, 0), Vector2(10, 0),
		Vector2(10, 0), Vector2(0, 10),
		Vector2(0, 10), Vector2(0, 0)
	]
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
	var angle_deg: float = 60 * i - 30 # var angle_rad = PI / 180 * angle_deg
	var rad: float = deg_to_rad(angle_deg)
	return Vector2(
		center.x + side * cos(rad),
		center.y + side * sin(rad))

"""


In a regular hexagon the interior angles are 120°.
There are six “wedges”, each an equilateral triangle with 60° angles inside.
Each corner is size units away from the center. In code:
	
To fill a hexagon, gather the polygon vertices at hex_corner(…, 0) through hex_corner(…, 5).
To draw a hexagon outline, use those vertices, and then draw a line back to hex_corner(…, 0).
"""
