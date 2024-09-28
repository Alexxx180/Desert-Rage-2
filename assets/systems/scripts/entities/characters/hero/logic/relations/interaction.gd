extends Node

func set_control(interaction: Node2D, environment: Node) -> void:
	var push: Node = environment.interaction.push
	interaction.push.body_entered.connect(push.forward)
