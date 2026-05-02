extends Node

#@onready var floors: Node = $floors
#@onready var seat: Node = $seat
@onready var ride: Node = $ride

func controls(platform: CharacterBody2D) -> void:
	var work: Node = platform.logic.work
	var stand: StaticBody2D = platform.logic.see.stand
	stand.box = platform
	ride.controls(platform, work.ride)
