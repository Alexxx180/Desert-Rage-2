extends Node

@onready var box: CharacterBody2D = Defaults.ENTITY
var hero: CharacterBody2D
var target: Rect2

func set_hero_action(action: String) -> void:
	# hero.to.act.turn_around(Vector2.ZERO) #hero.velocity = Vector2.ZERO; hero.logic.work.input.topdown.levels.jump.feet.deployment.reset_direction()
	print("TELEPORTING: ", target.position + target.size)
	hero.to.moves.set_move_action(action)
	hero.to.moves.set_base_stance("move")
	hero.to.moves.jump.sequence(true)

func set_box(next: CharacterBody2D) -> void:
	box = next

func delta(b: Vector2, a: Vector2) -> Vector2: return b - a

func teleport(next: Vector2, action: String = "jump") -> void:
	target = Rect2(hero.position, delta(next, hero.position))
	set_hero_action(action)

func dash(force: Vector2, action: String = "jump") -> void:
	teleport(hero.position + force, action)

func move(proportion: float) -> void:
	if box != Defaults.ENTITY:
		if proportion == 1.0:
			hero.position = box.ledge
		else:
			hero.position = target.position + delta(box.ledge, target.position) * proportion
	else:
		hero.position = target.position + target.size * proportion #print("TP MOVE: ", target.position + target.size) # print("JUMP TARGET POS: ", target.position, " + SIZE: ", target.size)
