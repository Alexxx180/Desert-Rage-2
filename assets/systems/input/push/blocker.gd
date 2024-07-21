extends Timer

@onready var interaction: CollisionShape2D = get_parent()
@onready var walls: StaticBody2D = $walls

func _come_off():
	walls.process_mode = Node.PROCESS_MODE_DISABLED
	stop()

func cancel_push():
	walls.process_mode = Node.PROCESS_MODE_INHERIT
	interaction.pull()
	interaction.is_pushing = false
	start()

func can_push() -> bool:
	return walls.process_mode != Node.PROCESS_MODE_INHERIT
