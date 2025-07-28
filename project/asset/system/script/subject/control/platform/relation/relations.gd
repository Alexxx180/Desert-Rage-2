extends Node

@onready var floors: Node = $floors
@onready var seat: Node = $seat
@onready var ride: Node = $ride

func controls(platform: CharacterBody2D) -> void:
	var processor: Node = platform.logic.processors
	floors.controls(platform, processor.floors)
	seat.controls(platform, processor.seat)
	ride.controls(platform, processor.ride)
