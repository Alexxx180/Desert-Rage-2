extends Area2D

@onready var distance: Node2D = $range
@onready var platforming: Node = $platforming

func _ready():
	platforming.distance = distance
	self.body_entered.connect(platforming.ledges.append)
	self.body_exited.connect(platforming.ledges.remove)
