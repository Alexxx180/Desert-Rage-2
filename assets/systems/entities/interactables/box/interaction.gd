extends Node2D

@onready var handle: Area2D = $handle
@onready var platform: StaticBody2D = $platform
@onready var seat: Node = $seat

func _ready():
	handle.push.transporter.seat = seat

func set_control_entity(box: Node2D):
	platform.set_control_entity(box)
	handle.set_control_entity(box)
