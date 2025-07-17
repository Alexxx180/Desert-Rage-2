extends Node

func controls(game: CanvasLayer, options: HFlowContainer) -> void:
	# var hud: Node = game.get_parent()
	var group: Node2D = game.get_node("../../group")
	var processor: Node = game.processor.game.play.skills
	var leader: CharacterBody2D = group.deploy.party.leader
	processor.fight = leader.logic.processors.world.fight
	processor.panel = options.skills
	options.skills.slap.pressed.connect(processor.reveal_aims)
