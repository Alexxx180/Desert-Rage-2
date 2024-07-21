extends Area2D

@export_range(0, 9) var F: int = 0
@export_range(1, 2) var height: int = 1

@onready var ledges: Array[Area2D] = [$left, $right, $forward, $backward]

func compare(ledge_floor: int) -> bool:
	return F + height == ledge_floor

func _on_step(body: Node2D):
	print("PLATFORMING")
	if body is CharacterBody2D:
		print("IS ON THE PLATFORM")
		var directions: Array[String] = []
		for ledge in ledges:
			ledge.add_direction(directions)
			
		body.to_platforming()
		body.platforming.coordinate(directions)
