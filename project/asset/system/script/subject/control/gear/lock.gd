extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var stand: Area2D = $stand

func _toggle(next: String) -> void:
	animation.play("locks/" + next)

func activate() -> void:
	activated = !activated
	_toggle("open" if activated else "close")

func _ready() -> void:
	if activated: _toggle("open")

	var border: TileMapLayer = get_node("../../border")
	var logic: TileMapLayer = get_node("../../tags")
	var tile: Dictionary = Tile.from_pos(logic, position)

	stand.box = self
	stand.seat = $seat

	var map_coords: Vector2i = Tile.find(border, position)
	var f: int = Tile.extract(border, map_coords, Tile.FLOOR)
	stand.seat.set_floor(f)
	#print("LOCK FLOOR: ", f)

	#print("lock tile: ", tile)
	logic.activators.add_lock(tile, self)
