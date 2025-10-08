extends Node

var is_pressed: bool = false
var execute: TileDecorator
var world_y: float = 0.0

@onready var deactivation: Timer = $deactivation

func switch_spring_tile() -> void: execute.switch(Vector2i(1, 0))

func press(condition: bool) -> bool:
	if condition: is_pressed = !is_pressed
	return condition

func activate_spring(hero_pos: Vector2) -> void:
	if press(not is_pressed):
		execute.from_pos(hero_pos)
		switch_spring_tile()
		deactivation.start()

func deactivate_spring() -> void:
	if press(is_pressed):
		switch_spring_tile()

func save(hero_y: float) -> void: world_y = hero_y
