extends Node2D

@onready var stats: Node
@onready var block: Timer = $blocker

func _ready():
	block.transporter = $transporter

func set_control_entity(box: Node2D):
	stats = box.stats
	block.transporter.set_control_entity(box)

func get_impulse_from(body: Node2D):
	if body is CharacterBody2D:
		block.is_pushing = false
		body.detectors.interaction.push_objects(self)
	else:
		block.stop_impulse()

func _on_push(body: Node2D):
	if block.is_contact(): get_impulse_from(body)
