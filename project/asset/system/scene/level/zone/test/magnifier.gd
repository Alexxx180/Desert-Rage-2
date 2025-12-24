extends CanvasLayer

@onready var eye: Control = $eye
@onready var port: Viewport = get_viewport()

func _physics_process(delta: float) -> void:
	port.world_to_screen(eye.player.global_position)
