extends Node2D

@onready var gap: Area2D = $gap
@onready var upland: Area2D = $upland

func turn_monitoring(state: bool) -> void:
	gap.monitoring = state
	upland.monitoring = state
