extends Node

var hero: CharacterBody2D

var target: Rect2

func teleport(next: Vector2) -> void:
	hero.velocity = Vector2.ZERO
	target.position = hero.position
	target.size = next - hero.position
	print("JUMP TARGET POS: ", target.position, " + SIZE: ", target.size)
	hero.view.animation.moves.set_move_action("jump")

func dash(force: Vector2) -> void:
	teleport(hero.position + force)
	# print("JUMPED: ", hero.position)

func move(proportion: float) -> void:
	hero.position = target.position + target.size * proportion
