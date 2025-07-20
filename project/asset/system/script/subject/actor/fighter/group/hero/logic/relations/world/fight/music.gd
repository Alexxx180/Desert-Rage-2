extends Node

func controls(_hero: CharacterBody2D) -> void:
	return # MOVED TO GROUP
	"""
	var music: Node2D = hero.logic.detectors.fight.music
	var tension: Node = hero.get_node("../../ost").tension
	
	music.nearby.body_entered.connect(tension.add_enemy)
	music.nearby.body_exited.connect(tension.drop_enemy)

	music.spawn.body_entered.connect(tension.add_spawn)
	music.spawn.body_exited.connect(tension.drop_spawn)
	"""
