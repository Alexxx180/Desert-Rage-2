extends Node

@onready var named: String = get_node("../../../..").name

var hero: CharacterBody2D



func _input(event: InputEvent) -> void:
	if Bit.of(hero.field, hero.PERSPECTIVE):
		platformer.input(event)
	else:
		topdown.input(event)

func _physics_process(delta: float) -> void:
	if Bit.of(hero.field, hero.PERSPECTIVE): #not Works.off(self):
		topdown.process_physics(delta)
		# TODO FIXME platformer connect
		# platformer.process_physics(delta)
	#print("hero slides: ", topdown.move.act.run.state.hero.name)
	#topdown.move.act.run.state.hero.move_and_slide()


var layers: Lay = Lay.new()
