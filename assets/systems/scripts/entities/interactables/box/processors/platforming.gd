extends Node

@onready var seat: Node = $seat
@onready var stance: Node = $stance
@onready var surface: Node = $surface

func _ready():
	surface.floors.on_floor_change.connect(seat.set_floor)

func set_stance(detector: Area2D):
	detector.body_entered.connect(stance.should_stand_at)
	detector.body_exited.connect(stance.disable_stand)

func set_floors(detector: Area2D):
	detector.body_entered.connect(surface.at_new_floor)
	detector.body_exited.connect(surface.at_old_floor)

func set_control_entity(box: Node2D):
	var platforming: Node2D = box.processors.platforming
	seat.update_view.connect(box.switch_stand)
	set_stance(platforming.stance)
	set_floors(platforming.floors)
