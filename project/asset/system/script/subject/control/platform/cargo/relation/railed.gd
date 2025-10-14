extends Node

@onready var timer: Timer = $timer

func controls(platform: CharacterBody2D) -> void:
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.start()
