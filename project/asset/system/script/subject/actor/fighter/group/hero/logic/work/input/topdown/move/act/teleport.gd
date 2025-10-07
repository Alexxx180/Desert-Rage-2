extends Node

var hero: CharacterBody2D
var target: Rect2

func set_hero_action(action: String) -> void:
	# hero.logic.work.input.topdown.move.act.turn_around(Vector2.ZERO) #hero.velocity = Vector2.ZERO; hero.logic.work.input.topdown.levels.jump.feet.deployment.reset_direction()
	print("TELEPORTING: ", target.position + target.size)
	hero.view.animation.moves.set_move_action(action)
	hero.view.animation.moves.set_base_stance("move")
	hero.view.animation.moves.jump.sequence(true)

func teleport(next: Vector2, action: String = "jump") -> void:
	target = Rect2(hero.position, next - hero.position)
	set_hero_action(action)

func dash(force: Vector2, action: String = "jump") -> void:
	teleport(hero.position + force, action)

func move(proportion: float) -> void:
	hero.position = target.position + target.size * proportion #print("TP MOVE: ", target.position + target.size) # print("JUMP TARGET POS: ", target.position, " + SIZE: ", target.size)
