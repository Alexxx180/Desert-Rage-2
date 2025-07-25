extends Node

var hero: CharacterBody2D

var target: Rect2

func teleport(next: Vector2, action: String = "jump") -> void:
	hero.velocity = Vector2.ZERO
	target.position = hero.position
	target.size = next - hero.position
	print("JUMP TARGET POS: ", target.position, " + SIZE: ", target.size)
	hero.view.animation.moves.set_move_action(action)
	hero.view.animation.moves.set_base_stance("move")
	hero.logic.processors.ui.input.platforming.jump.feet.deployment.reset_direction()

func dash(force: Vector2, action: String = "jump") -> void:
	# hero.view.animation.direction = force.normalized()
	# hero.view.animation.direct()
	print("FORCE: ", force)
	teleport(hero.position + force, action)
	# print("JUMPED: ", hero.position)

func move(proportion: float) -> void:
	hero.position = target.position + target.size * proportion
