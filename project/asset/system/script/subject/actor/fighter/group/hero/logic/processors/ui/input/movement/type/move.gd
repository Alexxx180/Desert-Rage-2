extends Node

var hero: CharacterBody2D
var target: Rect2

func teleport(next: Vector2, action: String = "jump") -> void:
	hero.velocity = Vector2.ZERO
	target = Rect2(hero.position, next - hero.position)
	hero.view.animation.moves.set_move_action(action)
	hero.view.animation.moves.set_base_stance("move")
	hero.logic.work.input.platforming.jump.feet.deployment.reset_direction()

func dash(force: Vector2, action: String = "jump") -> void:
	teleport(hero.position + force, action)

func move(proportion: float) -> void:
	hero.position = target.position + target.size * proportion
	print("TP MOVE: ", target.position + target.size) # print("JUMP TARGET POS: ", target.position, " + SIZE: ", target.size)
