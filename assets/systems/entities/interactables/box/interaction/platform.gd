extends Node2D

@onready var floors = $floors
@onready var stand = $stand/stance

func set_control_entity(box: Node2D):
	floors.set_control_entity(box)
	stand.box = box
