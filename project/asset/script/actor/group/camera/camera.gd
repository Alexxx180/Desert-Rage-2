extends Camera2D

@onready var analyze: Node2D = $analyze
@onready var deploy: Node2D = $deploy
@onready var music: Node2D = $music

var zooming: CameraZooming = CameraZooming.new()

func _ready() -> void: music.controls(self)

func set_overworld() -> void:
	zooming.overworld()
	zoom = Vector2(0.2, 0.2)
	# position_smoothing_enabled = true

func _input(_event) -> void:
	var z: float = zooming.zoom()
	if z != 0: zoom = zooming.new_zoom(zoom.x, z)
