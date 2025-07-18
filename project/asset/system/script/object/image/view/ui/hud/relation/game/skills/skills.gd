extends Node

func controls(game: CanvasLayer, options: HFlowContainer) -> void:
	# var hud: Node = game.get_parent()
	var group: Node2D = game.get_node("../../group")
	var play: Node = game.processor.game.play
	var leader: CharacterBody2D = group.deploy.party.leader
	play.skills.fight = leader.logic.processors.world.fight
	play.skills.panel = options.skills
	for hero in group.deploy.party.heroes:
		hero.logic.processors.world.fight.target_accept.connect(play.set_target)
	options.skills.slap.pressed.connect(play.skills.reveal_aims)
