extends Node

func _set_hero_command(hero: CharacterBody2D, options: Control, play: Node) -> void:
	hero.logic.work.world.fight.target_accept.connect(play.set_target)
	# TODO FIX AIMS
	# options.skills.skills[hero.name].slap.pressed.connect(play.skills.reveal_aims)

func controls(game: CanvasLayer, options: Control) -> void:
	# var hud: Node = game.get_parent()
	var group: Node2D = game.get_node("../../group")
	var play: Node = game.processor.game.play
	var leader: CharacterBody2D = group.deploy.party.leader
	group.deploy.select_hero.connect(play.skills.set_fight)
	play.skills.set_fight(leader)
	play.skills.panel = options.skills
	for hero in group.deploy.party.heroes:
		_set_hero_command(hero, options, play)
