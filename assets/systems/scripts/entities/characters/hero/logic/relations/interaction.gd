extends Node

func set_control(interaction: Area2D, environment: Node) -> void:
	interaction.push.body_entered.connect(environment.push.forward)
