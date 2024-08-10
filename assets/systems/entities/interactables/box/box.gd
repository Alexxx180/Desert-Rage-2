extends Node2D

@onready var stats: Node = $stats
@onready var interaction: Node = $interaction
@onready var geometry: Node = $interaction/handle/placement

func _ready() -> void:
	interaction.set_control_entity(self)
	stats.set_control_entity(self)
