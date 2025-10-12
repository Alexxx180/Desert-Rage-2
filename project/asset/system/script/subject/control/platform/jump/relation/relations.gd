extends Node

@onready var floors: Node = $floors
@onready var seat: Node = $seat
@onready var ride: Node = $ride

func controls(platform: CharacterBody2D) -> void:
	var work: Node = platform.logic.work
	floors.controls(platform, work.floors)
	seat.controls(platform, work.seat)
	ride.controls(platform, work.ride)
