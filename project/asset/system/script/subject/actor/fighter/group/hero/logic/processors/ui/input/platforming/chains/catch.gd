extends Node

signal chained(state: bool)

var input: Node
var spring: Node:
	get: return input.platforming.spring

var view: Node2D

func hero_in_midair() -> bool:
	return spring.state == spring.JUMPED

func ledge() -> void:
	encounter_ledge(true)

func ledge_in_midair() -> void:
	spring.successfully_landed()
	ledge()

func encounter_ledge(active: bool) -> void:
	disable_collision(active)
	chains_animation(active)
	
func chains_animation(active: bool) -> void:
	view.shadow.hanging = active
	view.animation.moves.set_environment("chains" if active else "ground")

func disable_collision(active: bool) -> void:
	input.modes.select(active)
	chained.emit(active)
	input.gravity.context(!active).collide_main()
