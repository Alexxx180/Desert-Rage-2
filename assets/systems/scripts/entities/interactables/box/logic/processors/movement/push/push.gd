extends Node

@onready var forward: ActionTimer = $forward
@onready var velocity: Node = $velocity

func start_forward(target: Vector2, force: float) -> void:
	print("START")
	print("SET VELOCITY: ", target, "FORCE: ", force)
	velocity.set_position(target * force)
	forward.start()

func stop_forward() -> void:
	print("STOP")
	forward.stop()
