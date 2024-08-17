extends Area2D

@onready var distance: Node2D = $range
@onready var platforming: Node = $platforming

func _ready():
	platforming.distance = distance
	self.area_entered.connect(platforming.ledges.append)
	self.area_exited.connect(platforming.ledges.remove)

func set_control_entity(hero: CharacterBody2D) -> void:
	distance.deployment.floors.body_entered.connect(platforming.jump_to_floor)
	platforming.set_control_entity(hero)
	distance.set_control_entity(hero)
