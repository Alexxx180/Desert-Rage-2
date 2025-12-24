extends CanvasLayer

@onready var eye: Control = $eye
@onready var port: Viewport = get_viewport()

func set_on_screen_position(screen_position: Vector2):
	var canvas_position = eye.get_canvas_transform().origin
	eye.global_position = screen_position - canvas_position# + Vector2(0, 96)

func _physics_process(delta: float) -> void:
	set_on_screen_position(eye.player.get_global_transform_with_canvas().get_origin())
