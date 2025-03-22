extends Node2D

@export var distance: Vector2i = Vector2i(24, 20)

@onready var box: Area2D = $box
@onready var ledge: Node2D = $ledge

#var _allow_monitoring: bool = true

func reset_monitoring(allow: bool) -> void:
	#_allow_monitoring = allow
	box.monitoring = allow

func set_direction(direction: Vector2i) -> void:
	if not Input.is_action_pressed("action") and direction != Vector2i.ZERO:
		box.position = direction * distance
		ledge.set_direction(direction)
		"""
		var pos: Vector2 = direction * distance
		ledge.target_position = pos * 2
		box.monitoring = _allow_monitoring and not ledge.is_colliding()
		box.position = pos
		# 
		if not ledge.is_colliding():
			box.position = ledge.target_position
		else:
			box.position = Vector2.ZERO
		"""
	
