extends Node

signal chained(state: bool)

var input: Node
var control: Node
var view: Node2D

func hero_in_midair() -> bool: return control.slide.falling

func ledge() -> void: encounter_ledge(true)

func ledge_in_midair() -> void:
	control.land()
	ledge()

func encounter_ledge(active: bool) -> void:
	disable_collision(active)
	chains_animation(active)
	
func chains_animation(active: bool) -> void:
	view.shadow.hanging = active
	view.animation.moves.set_environment("chains" if active else "ground")

func disable_collision(active: bool) -> void:
	input.is_platformer = active
	chained.emit(active)
	control.layers.context(!active).collide_main()
