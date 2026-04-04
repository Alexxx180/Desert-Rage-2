extends Node2D

const distance: int = 57

@onready var directions: Dictionary = {
	Vector2i(-1, -1): $top_left, Vector2i(0, -1): $top_center,
	Vector2i(1, -1): $top_right, Vector2i(-1, 0): $left_center,
	Vector2i(1, 0): $right_center, Vector2i(-1, 1): $bottom_left,
	Vector2i(0, 1): $bottom_center, Vector2i(1, 1): $bottom_right
}
@onready var jump_zone: Node2D = directions[Vector2i(0, -1)]
@onready var dir: Vector2i

var target_ground: Vector2 = Vector2.ZERO
var floors: Node
var recursed: int = 0
