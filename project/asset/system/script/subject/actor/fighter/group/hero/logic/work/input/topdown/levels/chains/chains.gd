extends Node

signal chained(state: bool)

@onready var catch: Node = $catch

var see: Node2D
var hanging: bool = false

func process_physics(delta: float) -> void:
	if see.border.is_colliding():
		if hanging:
			hanging = false
			catch.encounter_ledge(false)
		return
	#view.animation.moves.hero.to.act.velocity.forget()

	if see.pillar.is_colliding():
		hanging = see.unit.is_colliding()
		if not hanging:
			catch.encounter_ledge(false)
	
	if see.unit.is_colliding() and catch.hero_in_midair():
		hanging = true
		catch.ledge_in_midair()
	elif hanging:
		catch.ledge()
