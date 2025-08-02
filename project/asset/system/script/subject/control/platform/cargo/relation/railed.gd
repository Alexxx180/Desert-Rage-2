extends Node

@onready var timer: Timer = $timer

func controls(platform: CharacterBody2D) -> void:
	var stand: Area2D = platform.detectors.stand
	var processor: Node = platform.processor

	processor.cargo.platform = platform
	stand.body_entered.connect(processor.cargo.load_cargo)
	stand.body_exited.connect(processor.cargo.free_cargo)

	timer.timeout.connect(platform.detectors.ledge.sync_traps)
	timer.start()
