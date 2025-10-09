extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var stand: Area2D = $stand

func _toggle(next: String) -> void:
	animation.play("locks/" + next)

func activate() -> void:
	activated = !activated
	_toggle("open" if activated else "close")

func _set_seat(border: TileDecorator) -> void:
	stand.box = self
	stand.seat = $seat
	stand.seat.set_floor(border.extract_at_pos(position, Tile.FLOOR))

func _set_tags(tags: TileDecorator) -> void:
	var tile: Dictionary = tags.from_pos(position)
	tags.layer.activators.add_lock(tile, self)

func _ready() -> void:
	if activated: _toggle("open")

	var lay: Node2D = get_node("../group").lay
	_set_seat(lay.border)
	_set_tags(lay.tags)
